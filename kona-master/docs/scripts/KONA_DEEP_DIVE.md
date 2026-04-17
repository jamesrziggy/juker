# Kona K3 Interpreter — Deep Dive

Everything found from source code analysis, GitHub issues, wiki research,
and hands-on testing. April 2026.

---

## 1. What Kona Actually Is

Kona is an open-source reimplementation of Arthur Whitney's K3 language.
K is a synthesis of APL and LISP — the fundamental data construct is a
list (like LISP), not a multi-dimensional array (like APL). It uses
ASCII only, no special keyboard needed.

The C source code deliberately replicates Whitney's ultra-terse style.
His buddy memory allocator is 11 lines. The traditional C version of the
same algorithm is ~750 lines. Every function name is 1-3 characters.
Every macro compresses control flow into single lines. This is by design —
the entire interpreter fits in ~12,000 lines of C.

Repo: github.com/kevinlawler/kona — 1,407 stars, 67 open issues, ISC license.
Last pushed June 2023. Not actively maintained.

---

## 2. The K Object — The Only Data Structure

Everything in Kona is a K object. One struct. That's it.

```c
// from ts.h line 32
typedef struct k0 {
    I _c,   // packed: upper bits = reference count, lower 8 bits = pool lane size
    t,      // type tag (-4 to 7)
    n;      // element count
    struct k0 *k[1];  // flexible array member — ALL data lives here
} *K;
```

K is a pointer to this struct. The `k[1]` at the end is the C89 "struct hack" —
it's actually a variable-length array. The data gets cast to different types
depending on what `t` says:

- `kI(x)` casts to `I*` (64-bit integers)
- `kF(x)` casts to `F*` (doubles)
- `kC(x)` casts to `C*` (bytes/chars)
- `kS(x)` casts to `S*` (symbol pointers)
- `kK(x)` casts to `K*` (list of K objects)

### Type Tags

| t   | What it is | Example |
|-----|------------|---------|
| -4  | Symbol vector | `` `a`b`c `` |
| -3  | Char vector (string) | `"hello"` |
| -2  | Float vector | `1.1 2.2 3.3` |
| -1  | Int vector | `1 2 3` |
|  0  | General list (list of K pointers) | `(1;"hello";`sym)` |
|  1  | Int atom | `42` |
|  2  | Float atom | `3.14` |
|  3  | Char atom | `"c"` (single char) |
|  4  | Symbol atom | `` `hello `` |
|  5  | Dictionary | `.((`a;1;);(`b;2;))` |
|  6  | Nil | `_n` |
|  7  | Executable/function | `{x+1}`, `+`, verb references |

**Key insight**: Negative type = vector. Positive type = atom. Type 0 = general
list (mixed types). This means K knows at the type level whether something is
homogeneous (all ints, all floats) or heterogeneous (general list). Homogeneous
vectors are stored as flat C arrays with zero overhead per element.

### Type 7 — Executable Code

Type 7 objects have 8 subtypes stored in `n`:

- n=0: Word list from parser (unexecuted expression)
- n=1: Derived verb (verb+adverb combination)
- n=2: C function from dlopen (the 2: verb)
- n=3: Brace function `{body}`

The internal layout has 8 slots:
```
CONTEXT, DEPTH, CODE, LOCALS, PARAMS, CONJ, CACHE_WD, CACHE_TREE
```

CODE for brace functions is the source string as a char vector.
CACHE_WD and CACHE_TREE cache the parsed form so re-invocation skips parsing.
CONJ holds projected (partially applied) arguments.

---

## 3. "No Stinky Strings" — The Philosophy

K distinguishes three string-like things and treats them VERY differently:

### Character Atoms (type 3)
A single byte. `"c"` with count 1. Just a number that happens to display
as a letter.

### Character Vectors (type -3)
A sequence of bytes. `"hello"` with count 5. Internally it's a flat byte
array with a null terminator (the `sz()` function adds 1 extra byte for
chars). The null byte is NOT counted in `n`.

These exist for actual text — things humans read. Messages, file content,
display output.

### Symbols (type 4)
Interned identifiers. `` `hello `` is type 4 with count 1 — regardless of
how many characters are in the name. The `sp()` function in `ks.c` interns
the string into a global AVL tree (the `SYMBOLS` tree). After interning,
the symbol is represented by a single pointer. Two symbols are equal if
and only if their pointers are equal — O(1) comparison, no character
scanning needed.

Symbols cannot contain null bytes. They're like atoms in Erlang or
keywords in Ruby — identity, not content.

### The Philosophy

The entire K variable namespace (the "K-tree") is a dictionary hierarchy
using symbol paths. All dictionary keys are symbols. All naming uses symbols.

Where other languages would do:
```python
data = {"name": "james", "age": 30}  # string keys, string parsing
```

K does:
```k
data: .((`name;"james";);(`age;30;))  / symbol keys, typed values
```

The rule: **if you're parsing strings, your data representation is wrong.**

- Use symbols for names/keys (interned, O(1) comparison)
- Use typed vectors for data (ints are ints, not "30")
- Use binary serialization (1:) for persistence, not text formats
- Use IPC (3:/4:) to send K objects directly between processes
- The `$` verb (format) is a one-way street: K data → display string
- There is no regex. No string parsing primitives. If you need to parse,
  restructure your data.

This is why building a JSON library in K feels wrong — JSON is the
embodiment of "stinky strings." Everything is text. Numbers are text.
Booleans are text. You parse it all back out. K says: don't do that.
Keep your data typed. Only convert to strings at the boundary where
you talk to systems that insist on strings (HTTP APIs, config files, etc).

---

## 4. Memory Management — The Pool Allocator

Kona uses a custom pool allocator, not malloc/free.

### How It Works

Power-of-2 size classes from 2^6 (64 bytes, cache-line aligned) up to
2^26 (64 MB). The `KP[]` array holds a freelist for each size class.

**Allocation** (`newK` → `kalloc` → `kallocI`):
1. Compute size: `sz(t,n)` = 3 * sizeof(I) + n * bytes_per_element + (1 if char type)
2. Find lane: `lsz(k)` = ceil(log2(size)), minimum 6
3. If lane ≤ 26: pull from pool. If pool empty, mmap a page and
   subdivide into blocks chained as a freelist.
4. If lane > 26: direct mmap allocation.

**Deallocation** (`cd`):
1. Decrement refcount. If still > 0, return.
2. For type 0 and 5: recursively cd() all children (reverse order for type 0).
3. For type 7: cd() internal slots (CODE, LOCALS, PARAMS, CONJ, etc).
4. Check if memory-mapped file or oversized: munmap. Otherwise: zero the
   block and push onto freelist.

**Reference counting** (`ci`/`cd`):
- `ci(x)` increments refcount on x and all children.
- `cd(x)` decrements. Frees when count hits 0.
- Refcount is stored in upper bits of `_c` field (lower 8 bits = pool lane).
- `rc(x)` extracts count via `x->_c >> 8`.

### What Causes Bus Errors

1. **Memory-mapped files**: The 1: verb maps files directly into memory.
   If the file gets truncated or deleted while K holds a pointer to it,
   the next access hits an unmapped page → SIGBUS.

2. **Freelist corruption**: `unpool()` uses a sentinel check
   `(V)0x200 > *L` to detect empty pools. If a freelist pointer gets
   corrupted to a value between 0x200 and a valid address, it follows
   the bad chain → crash.

3. **`repool` on bad pointer**: Zeros the block with `memset(v,0,k)`.
   If `v` is garbage, this writes zeros to random memory.

4. **`kexpander` (mremap)**: If the size calculation overflows or the
   lane size stored in `_c` is wrong, the remap corrupts adjacent memory.

5. **Binary reader has no bounds checking**: The source literally says
   "K3.2 Bug: does not check boundary and will segfault on bad binary data"
   (line 855 of 0.c).

---

## 5. The Parser (p.c)

The parser works in stages:

### Stage 1: Completeness Check
`complete()` uses a pushdown automaton (PDA) with a DFA to determine if
input needs more lines. Tracks bracket nesting `()[]{}` and quote state.
Stack limited to 99 depth.

### Stage 2: Syntax Pre-check
`syntaxChk()` is a long chain of if-statements checking character sequences
for known-bad patterns. Returns magic numbers (10, 20, 25, 30...) that
are not documented. Brittle — should be refactored as a single pass but
isn't (noted in source comments).

### Stage 3: Marking
The input string gets an integer mark array. Each character is tagged:
MARK_END (`;` or `\n`), MARK_SYMBOL, MARK_NAME, MARK_NUMBER, MARK_VERB,
MARK_ADVERB, MARK_CONDITIONAL, MARK_QUOTE, MARK_BRACKET/PAREN/BRACE,
MARK_IGNORE. Negative marks = start of token.

### Stage 4: Capture
`capture()` converts marked tokens into K objects — numbers become int/float K,
names are looked up in the K-tree (KTREE), verbs become dispatch table offsets.
Result is a type-7 K whose CODE slot holds a -4 vector of "words" (pointers
into the dispatch table or pointers to K objects for data).

### The Colon Problem
The `:` character has 9 different uses (noted at lines 169-178 of p.c):
assignment, global assignment, monadic force, I/O verbs, conditional,
early return, and more. This is the most overloaded token in the language
and the source of many parser edge cases.

---

## 6. The Evaluator (kx.c)

### Main Entry: `ex(K a)`
Takes a type-7 K from the parser. Sets flags, calls `ex_()` → `ex0()`.

### Execution Loop: `ex0(V *v, K k, I r)`
Switches on `r` (context):
- r=0: Sequential statements (semicolons)
- r=1: Paren/function body — collapses result
- r=2: Brackets — returns list
- r=4: Conditional `:[...]`
- r=5,6: while/if loops
- r=7: do loops

### Expression Evaluation: `ex1()`
Single expression, right-to-left. This is where K's evaluation order lives.
`2*3+4` = 14, not 10.

### Function Application: `vf_ex()`
The workhorse. Handles:
- Dispatch table verbs (built-in +, -, *, etc)
- Derived verbs (verb+adverb like `+/`)
- Projections (partial application like `+[1;]`)
- Brace functions (builds local dict, merges params, re-parses if needed)
- Dynamically loaded C functions (from 2:)

For brace functions: builds a local dictionary tree, merges parameters,
checks the CACHE_WD slot for previously parsed form, and calls `ex()`
recursively. Stack overflow protection at DEPTH > 500.

### Adverb Application: `dv_ex()`
Routes to over, scan, each, eachright, eachleft, eachpair based on valence.
Stack check uses `stk > 2e6` which is essentially unbounded.

### Thread Safety: None
Line 122 of ts.h: `#define __thread` (empty) on non-Win32. ALL "thread-local"
variables are actually globals. The interpreter is NOT thread-safe.

---

## 7. I/O System (0.c)

### Text I/O (0:)
- **Read**: `0:"file"` → mmap file, split on newlines in 3 passes
  (count lines, count lengths, copy data). Returns list of char vectors.
- **Write**: `"file" 0: data` → mmap file, write char vectors.
  Can write to stdout with `\`0:`.
- **DSV reader**: `(types;delim) 0: \`file` — delimiter-separated values.
  Types are chars from "IFCS" (int, float, char, symbol).
- **Fixed-width reader**: `(types;widths) 0: \`file` — positional columns.

### Binary I/O (1:)
- **Read**: `1:"file"` → mmap and reconstruct K objects from binary format.
  This is the "K way" to persist data — no parsing, no strings.
- **Write**: `"file" 1: data` → serialize K objects to binary.
- **WARNING**: No bounds checking on read. Corrupt files crash the interpreter.

### Dynamic Library Loading (2:)
```
func: "libfile" 2: (`funcname; valence)
func[arg1; arg2; ...]
```
Calls `dlopen(RTLD_LAZY|RTLD_LOCAL)` → `dlsym()`. Stores function pointer
in a type-7 K with n=2. Max 7 arguments. Does NOT call `dlclose` (matches
K3.2 behavior). The loaded function becomes a first-class K verb.

### IPC (3: / 4:)
- **3: monadic**: Open/close TCP handle. `h: 3:(\`"host";port)`
- **3: dyadic**: Async send. `h 3: "expr"` — fire and forget.
  Calls `.m.s` handler on receiver.
- **4: dyadic**: Sync send. `h 4: "expr"` — blocks for response.
  Calls `.m.g` handler on receiver.
- **Shell exec**: `` \`3:"cmd" `` = fork+exec (no capture).
  `` \`4:"cmd" `` = popen (captures stdout as list of strings).
- **TCP client**: `(\`"host";port) 4: "raw data"` — raw TCP.
  Does getaddrinfo + socket + connect + write + read.

### Server Mode
- `./k -i PORT` — K binary protocol IPC server (select loop, multiple connections)
- `./k -h PORT` — HTTP server
- Handlers: `.m.s` (async), `.m.g` (sync), `.m.c` (close), `.m.h` (HTTP)

### File Append (3: / 5:)
- `"file" 3: data` — append without sync
- `"file" 5: data` — append with sync

### Byte I/O (6:)
- `"file" 6: "raw bytes"` — write raw bytes
- `6: "file"` — read raw bytes

---

## 8. System Commands (Backslash)

| Command | Action |
|---------|--------|
| `\` | Help menu |
| `\0` | Datatype help |
| `\+` | Verb help |
| `\'` | Adverb help |
| `\:` | I/O verb help |
| `\_` | Reserved word help |
| `\.` | Assignment/control flow help |
| `\b [s\|t]` | Break mode (stop/trace/none) |
| `\d [d\|^]` | Change K directory (namespace) |
| `\e [n]` | Error flag (0=off, 1=on, 2=exit) |
| `\l f` | Load script f or f.k |
| `\p [n]` | Print precision (0=full) |
| `\r [s]` | Random seed (0=random) |
| `\s f` | Step (debug) script |
| `\t [n]` | Timer interval in msec |
| `\t e` | Measure runtime of expression |
| `\v [d\|^]` | Show K directory |
| `\w` | Workspace resources |
| `\cmd` | Execute shell command |
| `\\` | Exit |

---

## 9. Reserved Words (Underscore Builtins)

### Constants
| Name | Description |
|------|-------------|
| `_T` | Current UTC Julian day + fraction |
| `_a` | Command-line arguments |
| `_c` | Message source address |
| `_d` | Current K-tree path |
| `_f` | Anonymous reference to current function |
| `_h` | Hostname |
| `_i` | Index of current amendment |
| `_k` | Build date string |
| `_n` | Nil |
| `_p` | Host port |
| `_s` | Space: used, allocated, mmapped, max |
| `_t` | Current UTC time (integer) |
| `_v` | Current global variable under amendment |
| `_w` | Message source handle |

### Math Functions
| Name | Description |
|------|-------------|
| `_abs` | Absolute value |
| `_ceil` | Ceiling (intolerant) |
| `_ceiling` | Ceiling (tolerant) |
| `_floor` | Floor (intolerant) |
| `_cos` | Cosine |
| `_sin` | Sine |
| `_tan` | Tangent |
| `_acos` | Inverse cosine |
| `_asin` | Inverse sine |
| `_atan` | Inverse tangent |
| `_cosh` | Hyperbolic cosine |
| `_sinh` | Hyperbolic sine |
| `_tanh` | Hyperbolic tangent |
| `_exp` | Exponential (e^x) |
| `_log` | Natural logarithm |
| `_sqrt` | Square root |
| `_sqr` | Square |
| `_inv` | Matrix inverse |
| `_dot` | Dot product |
| `_mul` | Matrix multiply |
| `_lsq` | Least squares |
| `_bin` | Binary search |
| `_binl` | Binary search (multiple elements) |
| `_draw` | Random draw. `_draw[3;10]` = 3 random ints 0-9 |
| `_hat` | Power (x^y) |
| `_di` | Delete element at index |
| `_dv` | Delete value |
| `_dvl` | Delete several values |

### String Functions
| Name | Description |
|------|-------------|
| `_ss` | Substring search. `_ss["hello";"l"]` → `2 3` |
| `_ssr` | String search & replace. `_ssr["hello";"l";"r"]` → `"herro"` |
| `_sm` | String match (glob). `_sm["test.txt";"*.txt"]` → `1` |
| `_sv` | Scalar from vector (base conversion) |
| `_vs` | Vector from scalar (base conversion) |

### Encoding/System
| Name | Description |
|------|-------------|
| `_bd` | Serialize K object to bytes |
| `_db` | Deserialize bytes to K object |
| `_ci` | Char from int code |
| `_ic` | Int code from char |
| `_dj` | Date from Julian day |
| `_jd` | Julian day from date |
| `_gtime` | GMT time |
| `_ltime` | Local time |
| `_lt` | Timezone offset |
| `_getenv` | Read environment variable |
| `_setenv` | Set environment variable (BUGGY — segfaults) |
| `_host` | DNS lookup |
| `_exit` | Exit with status code |
| `_size` | File size in bytes |
| `_hash` | Hash function |
| `_in` | Membership test |
| `_lin` | Membership test (multiple) |

---

## 10. Known Bugs — From GitHub Issues and Source

### Crash Bugs (Segfault / Bus Error)

**#468 — AFL fuzzing found multiple segfaults.**
Someone ran AFL on Kona and found many crash-inducing inputs. Backtraces
show crashes in ex1() (evaluator), unpool() (memory allocator), join()
(array ops). A full fuzz corpus exists at rwhitworth/kona-fuzz. These are
NOT fixed.

**#634 — Memory leak in file I/O.**
Repeating `"file" 1: data; 1: "file"` leaks ~80-200 bytes per iteration.
mUsed grows monotonically. Eventually segfaults.

**#552 — Ackermann's function blows the stack.**
`ack[3;5]` is 330x slower than k3, uses 16x more memory. `ack[3;6]`
runs out of stack entirely. Recursive function overhead is extreme.

**Binary reader has no bounds checking.**
Source comment at line 855 of 0.c: "K3.2 Bug: does not check boundary
and will segfault on bad binary data." Never fixed.

### Parser Bugs

**#646 — Inline backslash broken.**
`\` inside expressions gets interpreted as a shell command instead of
debug trace. `f:{  \x+y}` tries to execute `x+y}` in the shell.

**#440 — Parsing differences with k2.8.**
Various expressions parse differently than the reference implementation.

**#389 — Error position wrong.**
The caret in error messages points to the wrong character. Position
changes depending on expression complexity.

### Eval Bugs

**#289 — Dot index of nilads.**
`{42}.()` should return the function itself (Index), not evaluate it.

**#398 — Undefined functions produce results instead of errors.**
A lambda calling undefined `p` returns permutation results instead of
a value error.

### Missing Features

**#304 — No dependencies, triggers, or GUI.**
Earlier K versions had spreadsheet-like dependencies, triggers, and
a native GUI. Never implemented in Kona.

**#463 — Stop/debug not working.**
`\b s` stops but doesn't show the stop line. Tracked variables
unavailable. `_f` doesn't work in debug context.

### Compatibility Issues

**#632 — Script loading 250x slower than k2.8.**
Loading a script: 8263ms in Kona vs 32ms in k2.8.

**#618 — Binary format incompatible across architectures.**
64-bit Kona and 32-bit k2.8 produce different formats. Files not
cross-loadable.

**#320 — Random numbers not reproducible.**
k2.8 starts with seed -314159 and `\r` resets to it. Kona starts
with a random seed and doesn't properly reset.

---

## 11. The Macro Language

Kona's C source is written in a compressed macro language. Understanding
these is essential for reading the code:

| Macro | Expansion |
|-------|-----------|
| `R` | `return` |
| `Z` | `static` |
| `O(...)` | `printf(...)` |
| `P(x,y)` | `if(x) return y` |
| `U(x)` | `if(!x) return 0` |
| `DO(n,x)` | `{I i=0,_i=(n);for(;i<_i;++i){x;}}` |
| `SW` | `switch` |
| `CS(n,x)` | `case n: x; break` |
| `CSR(n,x)` | `case n: x` (fallthrough) |
| `I` | `long long` (64-bit int) |
| `F` | `double` |
| `C` | `unsigned char` |
| `S` | `char *` |
| `V` | `void *` |
| `K` | `struct k0 *` |
| `SE` | `kerr("signal")` |
| `TE` | `kerr("type")` |
| `LE` | `kerr("length")` |
| `VE` | `kerr("value")` |
| `NYI` | `kerr("nyi")` |
| `ci(x)` | increment refcount |
| `cd(x)` | decrement refcount (free if 0) |

---

## 12. Execution Flow

```
main()
  → kinit()        // initialize K-tree, symbols, dispatch table
  → attend()       // event loop: select() on stdin + network sockets
    → prompt()     // read input line
    → X(s)         // entry point for evaluation
      → wd(s,n)    // parse: mark → capture → build type-7 K
      → ex(K)      // evaluate
        → ex_()    // handle projections
        → ex0()    // statement sequencing
        → ex1()    // single expression (right-to-left)
          → vf_ex()  // function/verb application
          → dv_ex()  // adverb application
```

The global K-tree (KTREE) is a type-5 dictionary that serves as the
variable namespace. Variables are looked up/created via denameD/denameS.
Current directory tracked by `d_` (defaults to `.k`).

---

## 13. How The Seeder Tech Connects

James's kona-rs seeder (at /home/james/Documents/src/) already ported
key Kona internals to Rust:

- **k.rs** — The K object struct, translated from ts.h. Same type tags,
  same layout philosophy. KType enum mirrors the C t field.

- **va.rs** — K3 scalar arithmetic verbs from va.c. Includes the
  SCALAR_INIT macro logic for type promotion and broadcasting. Has
  _dot (dot product), _mul (multiply), plus, minus — the core math
  that makes the seeder's relevance scoring work.

- **piece.rs** — BitTorrent-style chunking. Each piece has a K float
  array embedding computed via TF-IDF. Uses K's _dot for relevance
  scoring. This is the "no stinky strings" philosophy in action —
  text gets converted to typed numeric vectors immediately, and all
  operations happen on the vectors.

- **seeder.rs** — The swarm. Worker threads hold piece shards. Query
  broadcasts to all workers, each computes _dot scores, results merge.
  This is K's broadcast-gather pattern implemented as OS threads.

- **learn.rs** — 5-pass distillation. Uses the seeder to progressively
  refine a memory embedding. Each pass re-scores against accumulated
  memory with escalating weight (0% → 85%). The noise floor emerges
  from median statistics — automatic epistemic humility.

The connection: Kona (the interpreter) and kona-rs (the Rust port)
share the same mathematical foundation. The seeder's TF-IDF + _dot
pipeline is K's array math applied to text relevance. The seeder
could use Kona directly for prototyping new scoring functions —
write the math in K, test it interactively, then port to Rust for
production speed.

Kona as a math scratchpad for the seeder:
```k
/ prototype a relevance score in K
embed: {(#x)# 0.0}          / zero embedding of size x
tfidf: {... }                / compute tf-idf
score: {_dot[x;y]}           / relevance = dot product
topk:  {x@(>y)@!z}          / top z by score y from data x
```

The seeder's noise floor detection, confidence scoring, and curriculum
learning could all be prototyped in K first — K's array operations
make it trivial to explore different scoring functions interactively
before committing to Rust code.

---

## 14. What We Built: json.k

A pure-K JSON encoder/decoder library. Lives at:
/home/james/Documents/kona-master/json.k

### What Works
- Encode K dictionaries to JSON strings
- Decode flat JSON (string/number/null values) back to K dicts
- File read/write round-trip (jwrite / jread)
- Handles: integers, floats, strings, symbols, null
- Encoder handles int and float arrays too

### What Doesn't Work Yet
- Decoding JSON arrays (`[1,2,3]`) — needs dedicated parser
- Nested JSON objects — needs recursive descent
- Boolean true/false (K has no bool type, uses 0/1)
- Unicode escapes in strings

### Bugs Found During Development
1. `((expr)_x)` — double-paren before dyadic drop causes parse error.
   Workaround: `(expr)_ x` with space.
2. `". expr"` in script files — monadic dot at certain positions triggers
   namespace switching instead of eval. Workaround: `eval: (.:)` projection.
3. `","\ x` in script files — backslash-space is interpreted as system
   command by the script loader. Workaround: `csplit: (","\)` projection.
4. Passing `[1,2,3]` through eval (monadic dot) causes parse error.
   In one test sequence, this led to a bus error crash — likely heap
   corruption from the parser leaving a malformed type-7 object that
   the evaluator then dereferenced through a bad pointer.

### Parser Pitfalls for Script Authors
- Never use bare `\ ` inside functions in .k files — it becomes a system command
- Never use bare `. ` to start an expression — it becomes namespace switch
- Use projections `(verb:)` or `(delim\)` to safely capture monadic/scan verbs
- Avoid `((expr)_x)` — use `(expr)_ x` instead
- The `_setenv` builtin segfaults — don't use it
