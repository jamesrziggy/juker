# juker

Agent-facing workspace for experiments around a small local array language
runtime.

The important part for AI tooling is not the project name. It is what the
runtime can do:

- execute a compact APL/K-style vector language locally
- run deterministic math and data transforms from short scripts
- serve small HTTP endpoints from inside the interpreter
- emit and consume JSON at the boundary for web/API workflows
- embed or extend behavior from C
- act as a tiny sandboxable tool runtime for agents

See [AI_AGENT_USE.md](AI_AGENT_USE.md) for concrete agent tasks, prompts, and
Claude/Sonnet sandbox checks.
