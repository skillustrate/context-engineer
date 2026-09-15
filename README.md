# Context Engineer

Production-grade context engineering runtime architecture and skill for agentic AI coding assistants (Claude Code, Cursor, Antigravity, Copilot, Codex).

---

## Overview

Context engineering is the practice of deliberately curating what an AI coding agent sees, when it sees it, and how it is structured. In enterprise multi-agent workflows, naive prompt stuffing burns budgets and introduces hallucination cascades.

**Context Engineer** provides a deterministic runtime architecture that guarantees:
- **Prefix Invariance & Prompt Caching**: Aligns context with Anthropic, OpenAI, and Gemini KV cache layers, unlocking 75%–90% cost savings.
- **JIT Progressive Disclosure**: Replaces bulk file reads with a 3-tier AST skeleton and slice extraction pipeline.
- **Output Token Conservation**: Mandates structured search/replace and unified diff formats, cutting generation tokens by 95%.
- **Automated In-Band Verification**: Validates AST/syntax, type safety, and blast-radius scope boundaries before commits.
- **Enterprise Security**: Implements automated instruction detection and quarantine against prompt injection and MCP poisoning.

---

## Architecture: 4-Tier Memory Hierarchy

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                        DETERMINISTIC CONTEXT RUNTIME PIPELINE                          │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  [Tier 0: Static Prefix] Rules, Schema Contracts, Invariants  (Cached: 90% Cost Drop)  │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  [Tier 1: Semantic Layer] JIT AST Outlines, Symbol References (Progressive Disclosure) │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  [Tier 2: Episodic State] State DAG, Task Ledger, Cache Checkpoints                    │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  [Tier 3: Active Working] Scoped Chunk, Filtered Error (Stripped of vendor noise)      │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  [Execution & Evaluation] Diff Validation → Lint/Typecheck → State Ledger Commit       │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

| Tier | Name | Persistence | Invalidation Trigger | KV Cache Status |
|---|---|---|---|---|
| **Tier 0** | **Static Anchor** | Project Lifetime | Config / System Prompt changes | **Immutable Prefix** (100% Cache Hit) |
| **Tier 1** | **Semantic Index** | Repository State | Code commit / branch change | **JIT Indexed** (Query on demand) |
| **Tier 2** | **Episodic Ledger** | Session / Task Run | Task completion boundary | **Append-Only Delta** |
| **Tier 3** | **Working Buffer** | Turn / Substep | Every tool execution / generation | **Evictable Scratchpad** |

---

## Directory Structure

```
context-engineer/
├── plugin.json                              # Package manifest & skill registration
├── LICENSE                                  # MIT License
├── README.md                                # Root documentation & guide
├── AUDIT-REPORT.md                          # Cybersecurity & hardening audit
├── FINOPS-GUIDE.md                          # Token budgeting & FinOps ROI framework
├── SECURITY.md                              # Threat model & sanitization standards
├── skills/
│   └── context-engineering/
│       ├── SKILL.md                         # Core agent skill instructions & contract
│       └── README.md                        # Operational companion guide
└── evals/
    ├── README.md                            # Evaluation framework & scoring spec
    ├── cases/
    │   └── context-engineering.json         # 18 behavioral & benchmark eval cases
    ├── fixtures/
    │   └── context-engineering/             # Test fixtures & audit testbeds
    └── security/
        ├── SECURITY-CHECKLIST.md            # Pre-deployment verification gates
        └── context-engineering-security.json# Automated security eval cases
```

---

## Key Performance Indicators & Targets

| Metric | Target | Description |
|---|---|---|
| **Context Utilization Rate (CUR)** | ≥ 35% | Ratio of loaded tokens directly present in verified patches |
| **Cache Hit Efficiency (CHE)** | ≥ 85% | Ratio of cached input tokens across multi-turn sessions |
| **First-Attempt Pass Rate (FAPR)**| ≥ 70% | Patch verification success rate on turn 1 without repair loops |
| **Token Burn Per Task (TBPT)**    | < 4,500 | Total token spend from intake to verified green state |
| **Hallucination Rate**            | < 2% | Erroneous imports, missing paths, or hallucinated APIs |
| **Convention Adherence**          | > 95% | Deterministic linter adherence to project style contracts |

---

## Documentation

* [Core Skill Contract (SKILL.md)](skills/context-engineering/SKILL.md)
* [FinOps & Operational Guide](FINOPS-GUIDE.md)
* [Security Threat Model & Defenses](SECURITY.md)
* [Cybersecurity Audit Report](AUDIT-REPORT.md)
* [Evaluation Suite](evals/README.md)

---

## License

Distributed under the [MIT License](LICENSE). Copyright (c) 2026 skillustrate.
