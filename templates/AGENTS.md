# AGENTS.md — Context Engineering Architecture

## 4-Tier Memory Pipeline
- Tier 0: Static project contract & style invariants (cached prefix).
- Tier 1: AST skeletons & symbol interfaces (loaded JIT).
- Tier 2: Task ledger & state DAG (compacted per milestone).
- Tier 3: Working buffer (filtered error frames, active diff).

## Generation Standards
- Use diff patches only.
- Run typecheck and verification tests before reporting completion.
