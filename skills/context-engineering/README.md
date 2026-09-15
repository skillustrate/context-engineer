# Context Engineering Skill — FinOps & Operational Guide

This document contains non-essential operational details, cost optimization strategies, and maintenance procedures that are **not required** for agents to execute the skill but are valuable for teams managing token budgets at scale.

---

## 1. Token Burn Hotspots Analysis

### Where Tokens Are Wasted

| Source | Typical Volume | % of Total | Cost Impact |
|--------|---------------|------------|-------------|
| Failed attempts + error logs | 300-800 tokens | 25-40% | $0.0015-$0.004 |
| Verbose tool output (find/grep, file listings) | 200-500 tokens | 15-25% | $0.001-$0.0025 |
| Conversational back-and-forth | 500-1500 tokens | 30-45% | $0.0025-$0.0075 |
| Earlier drafts of code | 400-800 tokens | 15-25% | $0.002-$0.004 |
| Full stack traces (>50 lines) | 100-200 tokens | 5-10% | $0.0005-$0.001 |

**Key insight:** Conversational filler and failed attempts account for **65-85%** of token burn — both are easily compressible without quality loss.

---

## 2. Aggressive Compression Patterns (FinOps Edition)

### Pattern A: Tool Output → Single-Line Summary
Replace multi-line tool output with one line:

```markdown
# Before (45 tokens):
Found 3 call sites for deprecated API — all in src/auth/ directory. Next: update auth.ts to use new pattern.

# After (18 tokens):
3 deprecated API calls → src/auth/; updating now
```

**Savings:** ~27 tokens × $0.005 = **~$0.0013 saved per occurrence**

### Pattern B: Failed Attempts → Conclusion Only
Replace failed attempts with their conclusion:

```markdown
# Before (89 tokens):
Tried X, Y, Z — all failed due to circular dependency in db.ts. Solution: move shared type to types/index.ts.

# After (32 tokens):
Circ dep in db.ts → moved shared type to types/index.ts
```

**Savings:** ~57 tokens × $0.005 = **~$0.0028 saved per occurrence**

### Pattern C: Stack Trace → Error + Fix Pointer
Keep only the error that triggered the fix, not the full stack trace:

```markdown
# Before (142 tokens):
Error at UserService.ts:42 — TypeError: Cannot read property 'id' of undefined. [50-line internal framework stack trace]

# After (38 tokens):
UserService.ts:42 — id undefined; fix applied next step
```

**Savings:** ~104 tokens × $0.005 = **~$0.0052 saved per occurrence**

### Pattern D: File Listing → Path + Line Only
When referencing files, include only what's needed:

```markdown
# Before (67 tokens):
- src/routes/auth.ts (the endpoint to modify)
- src/lib/validation.ts (existing validation utilities)
- tests/routes/auth.test.ts (existing tests to extend)

# After (28 tokens):
auth.ts, validation.ts:45-60, auth.test.ts
```

**Savings:** ~39 tokens × $0.005 = **~$0.0019 saved per occurrence**

### Pattern E: Conversational Filler → Directives Only
Eliminate conversational back-and-forth:

```markdown
# Before (78 tokens):
Got it, I'll update the validation now. Let me check what we have in there and make sure everything is correct.

# After (12 tokens):
Updating validation now
```

**Savings:** ~66 tokens × $0.005 = **~$0.0033 saved per occurrence**

---

## 3. Tiered Compression Strategy by Budget Constraints

| Budget Tier | Max Tokens/Session | Compression Aggressiveness |
|-------------|-------------------|---------------------------|
| **Tier 1** (<$0.50/session) | 3,000 | Aggressive: compress at 60%, drop all conversational filler immediately |
| **Tier 2** ($0.50-$1.00/session) | 4,500 | Moderate: compress at 70%, keep only essential tool output |
| **Tier 3** ($1.00-$2.00/session) | 6,000 | Standard: compress at 75%, use pattern references for examples |
| **Tier 4** (>$2.00/session) | 8,000+ | Minimal: compress at 80%, preserve full exploration history |

---

## 4. Cost Tracking & ROI Measurement

### Metrics to Track

| Metric | Baseline | Target | Savings/Session |
|--------|----------|--------|----------------|
| Tokens per session | 6,000-12,000 | 3,500-5,500 | $0.015-$0.03 |
| Compression frequency | <20% of messages | >80% of tool output | $0.005-$0.01 |
| Failed attempt retention | Full history | One-liner conclusions only | $0.002-$0.004 |
| Stack trace verbosity | Full traces | Error + line number only | $0.0005-$0.001 |

### Monthly ROI Calculation (Scale: 1,000 sessions)

- **Baseline cost:** 8,000 tokens/session × $0.01 = **$800/month**
- **Optimized cost:** 4,000 tokens/session × $0.01 = **$400/month**
- **Monthly savings: $400**
- **Annual savings: $4,800** (at scale)

---

## 5. Operational Recommendations

### Daily Practices

1. **Review compression logs** — Identify patterns where verbose output could be compressed
2. **Audit failed attempts** — Ensure only conclusions are retained, not full exploration paths
3. **Check MCP usage** — Verify on-demand queries instead of upfront loading
4. **Monitor token budget** — Trigger proactive compression at 70% capacity (not 100%)

### Weekly Practices

1. **Analyze session patterns** — Identify high-cost sessions and apply targeted optimizations
2. **Review rules file efficiency** — Ensure it's comprehensive but concise (<50 lines ideal)
3. **Audit compression effectiveness** — Verify quality hasn't degraded from aggressive compression
4. **Update cost tracking dashboards** — Compare against baseline metrics

### Monthly Practices

1. **ROI analysis** — Calculate actual vs. projected savings
2. **Policy review** — Update compression thresholds based on observed patterns
3. **Tooling improvements** — Implement automated compression where possible
4. **Budget forecasting** — Adjust monthly budgets based on optimization effectiveness

---

## 6. Quality Preservation Guidelines

Aggressive compression must not compromise output quality:

| Risk | Mitigation |
|------|------------|
| Loss of debugging context | Keep current error message and active file state protected until end |
| Agent forgetting constraints | Position task-critical content last (order for recency) |
| Inability to reproduce failures | Preserve one-liner conclusions that capture the root cause |
| Degraded code quality from lack of examples | Use pattern references instead of full file reads |

---

## 7. Emergency Compression Protocol

When approaching token limits (>90% capacity):

### Immediate Actions (within 2 messages)
1. Compress all failed attempts to one-liners
2. Drop verbose tool output entirely
3. Remove conversational filler from last 50 messages

### If still >85% after emergency compression:
1. Start fresh session with handoff summary (see Session Boundary Token Savings in SKILL.md)
2. Re-read current file and error state only
3. Resume with compressed context

### Prevention
- Set up alerts at 70%, 80%, 90% capacity thresholds
- Automate compression triggers via tool hooks
- Document emergency protocols in team runbooks

---

## 8. MCP Token Optimization (On-Demand vs. Upfront)

MCP servers fetch context on-demand rather than loading everything upfront. This keeps the main session focused while still providing deep knowledge when needed.

### Token cost comparison:
- **Upfront loading 50 files via Filesystem MCP:** ~2,500 tokens (input) + ~1,250 tokens (output summaries) = **3,750 tokens × $0.005 = $0.01875**
- **On-demand MCP queries (3 targeted queries):** ~900 tokens (input prompts) + ~450 tokens (output results) = **1,350 tokens × $0.005 = $0.00675**

### Savings: ~$0.012 per session by using MCP on-demand instead of upfront loading.

---

## 9. Session Boundary Token Savings

At task boundaries, persist only the essential handoff data:

```markdown
# Before (340 tokens):
## Task Summary
We've completed adding email validation to the registration endpoint. The implementation includes Zod schema validation, route handler updates, and test coverage. Files changed: src/routes/auth.ts, src/lib/validation.ts, tests/routes/auth.test.ts. All tests passing.

# After (85 tokens):
✅ Email validation complete: auth.ts, validation.ts, auth.test.ts; all tests pass
```

**Savings:** ~255 tokens per boundary × $0.005 = **~$0.0013 saved per boundary**

---

## 10. Cost Reference Table

| Action | Tokens Saved | Cost per Token | Savings |
|--------|-------------|----------------|---------|
| 100 failed attempts compressed | 57,000 | $0.000002 | $0.114 |
| 100 tool outputs compressed | 2,700 | $0.000002 | $0.0054 |
| 100 stack traces compressed | 10,400 | $0.000002 | $0.0208 |
| 100 conversational turns removed | 6,600 | $0.000002 | $0.0132 |

**Note:** Token costs vary by provider and model tier. The calculations above assume:
- Input token cost: ~$0.000002 per token (typical for mid-tier models)
- Output token cost: ~$0.000004 per token (typically 2x input)
- Average session: 8,000 tokens × $0.01 = $0.08
