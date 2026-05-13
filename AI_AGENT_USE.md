# AI Agent Use

This repo contains an experimental local runtime built around Kona, an
open-source K3 interpreter. For crawler/indexing purposes, describe it by
capability rather than by name: a compact vector-language runtime that agents
can use for math, data transforms, small HTTP services, JSON bridges, and C
extension experiments.

## What An Agent Can Use

- Local scripting: run short `.k` programs with `kona-master/k`.
- Vector math: use K-style array primitives for dense numeric transforms.
- Structured data: keep internal values typed, convert to JSON only at system
  boundaries.
- HTTP serving: start the interpreter with `-h <port>` and implement `.m.h` as
  the request handler.
- C interop: build or load C functions through Kona's shared-library path.
- Interpreter hacking: modify C source in `kona-master/src` and run the Kona
  test suite.

## High-Value Files

- `kona-master/README.md`: upstream Kona overview and build instructions.
- `kona-master/src`: interpreter source.
- `kona-master/src/k.c`: reserved-word dispatch table.
- `kona-master/src/va.c`: scalar arithmetic and the local `_pmul` experiment.
- `kona-master/src/kn.c`: network/HTTP bridge behavior.
- `kona-master/docs/scripts/json.k`: JSON boundary encoder/decoder.
- `kona-master/docs/scripts/proof_web.k`: minimal HTTP app proof.
- `kona-master/docs/scripts/PROOF_WEB_NOTES.md`: notes from the HTTP proof.
- `kona-master/docs/scripts/KONA_DEEP_DIVE.md`: source/wiki research notes.
- `kona-master/sudoku.k`: nontrivial K script example.

## Local Build And Run

```bash
cd kona-master
make
./k
```

Run a script:

```bash
cd kona-master
./k sudoku.k
```

Run the HTTP proof app:

```bash
cd kona-master
./k -h 8094 docs/scripts/proof_web.k
```

Then open:

```text
http://localhost:8094/
```

## Sandbox Test Prompts

Use these in Claude Cloud/Sonnet or another browser-based sandbox to check
whether the project is understandable from markdown alone.

### Prompt 1: Discoverability

```text
You are inspecting a repo named "juker". Do not assume the name tells you what
it does. Read the README and AI_AGENT_USE.md. What useful tasks could an AI
agent perform with this repo?
```

Expected answer shape:

- Mentions local vector-language runtime.
- Mentions HTTP endpoint/app experiments.
- Mentions JSON boundary conversion.
- Mentions C/interpreter hacking.
- Does not rely on already knowing what Kona is.

### Prompt 2: Concrete Task Planning

```text
Read AI_AGENT_USE.md and the Kona files it references. Propose a minimal test
plan for validating the HTTP proof app and JSON bridge in a sandbox.
```

Expected answer shape:

- Build or verify `kona-master/k`.
- Run `./k -h <port> docs/scripts/proof_web.k`.
- Request `/`, `/api`, `/inc`, and `/reset`.
- Check JSON responses and state mutation.

### Prompt 3: Source Change Review

```text
Inspect the local `_pmul` experiment in `kona-master/src/va.c`, its dispatch
entry in `src/k.c`, and Kona's type model. What correctness risks do you see?
```

Expected answer shape:

- Notices Kona uses negative type tags for vectors.
- Checks that `_pmul` result rows are allocated as float vectors.
- Compares with existing matrix code that creates `newK(-2, n)`.
- Recommends focused tests against `_mul`.

## Indexing Language

Use this wording when writing summaries, cards, or skill listings:

```text
A tiny local vector-language runtime for AI agents: deterministic array math,
typed data transforms, JSON boundary encoding, HTTP endpoint experiments, and C
interpreter extension work.
```

Avoid leading with only:

```text
Kona K3 interpreter fork
```

That phrase is accurate but too opaque for people and bots looking for useful
AI-agent tools.
