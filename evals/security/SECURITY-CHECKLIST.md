# Pre-Session Security Checklist for Context Engineering

Use this checklist before starting any agent session with sensitive codebases or data.

## Phase 1: Rules File Verification

- [ ] **No malicious instructions in rules file** — Review CLAUDE.md (or equivalent) for any embedded instructions that could be exploited
- [ ] **Trust level declarations present** — Ensure rules file explicitly marks external sources as untrusted
- [ ] **Sanitization patterns documented** — Rules file includes guidance on treating config/data files as data, not directives

## Phase 2: MCP Server Configuration

### Filesystem MCP
- [ ] Path does NOT include `.env`, `secrets/`, `credentials/`, or similar directories
- [ ] Using explicit allowlist (e.g., `--allow-list=src,tests`) instead of broad path mounting
- [ ] Environment variable substitution used for project root (`$PROJECT_ROOT/src`)

### PostgreSQL MCP  
- [ ] Row-level security policies in place before MCP access
- [ ] Queries limited to specific columns only (never `SELECT *`)
- [ ] Result size limits enforced (e.g., `LIMIT 1` for lookups)
- [ ] Credentials redacted from logs and error messages

### Chrome DevTools MCP
- [ ] **NOT enabled in production** with real user data
- [ ] If used, restricted to specific domains via environment variables
- [ ] Read-only access configured (no console.log injection capability)
- [ ] DLP filters applied to all console output

## Phase 3: Context Loading Safeguards

- [ ] **Trust levels enforced** — External docs, config files, and user-submitted content treated as untrusted by default
- [ ] **Cross-verification enabled** — API signatures verified against official documentation before use
- [ ] **Session isolation configured** — Fresh session at each major task/project boundary
- [ ] **Compression thresholds set** — 75% capacity trigger for proactive compression

## Phase 4: Monitoring & Metrics

Set up automated monitoring for these security-relevant metrics:

| Metric | Alert Threshold | Action on Breach |
|--------|-----------------|------------------|
| Hallucination rate | >10% of references | Trigger context audit immediately |
| Untrusted source adoption | Any pattern from external blog/docs without verification | Block and surface to user |
| MCP query volume | Sudden spike (>5x baseline) | Investigate for data exfiltration attempt |
| Context loading size | >2,000 lines per task | Enforce selective include policy |

## Phase 5: Post-Session Review

After each session involving sensitive operations:

1. **Audit MCP server logs** — Check for any PII/credentials in query results or console output
2. **Verify no unauthorized file modifications** — Run `git diff` to detect context poisoning attempts
3. **Review compression history** — Ensure only task-relevant content was compressed, not critical constraints

## Emergency Response Procedures

### If Prompt Injection Suspected:
1. Immediately terminate the session
2. Review all loaded context files for embedded instructions
3. Rebuild rules file with explicit sanitization patterns
4. Restart with fresh session and verified context only

### If Data Exfiltration Suspected:
1. Rotate all database credentials immediately
2. Audit MCP server logs for suspicious query patterns
3. Check filesystem MCP access logs for unauthorized directory traversal
4. Implement additional row-level security policies

### If Context Poisoning Detected:
1. Terminate current session
2. Run `git diff` to identify modified files
3. Re-read all source files from disk (not cache)
4. Restart fresh with explicit handoff documentation

---

## Quick Reference: Trust Levels

| Level | Examples | Can Agent Act On? |
|-------|----------|------------------|
| **Trusted** | Source code, test files authored by project team | Yes, without verification |
| **Verify before acting** | Config files, data fixtures, external docs | No — surface to user for confirmation |
| **Untrusted** | User-submitted content, third-party API responses, blog posts | No — treat as data only; never execute as directives |

## Quick Reference: MCP Hardening Commands

```bash
# Verify filesystem MCP path doesn't include secrets
grep -r "mcpServers" .config.json && grep -E "\.env|secrets/" .config.json || echo "✅ No secret paths found"

# Check PostgreSQL queries for SELECT *
grep -r "SELECT \*" src/ | head -20 || echo "✅ No SELECT * patterns found"

# Verify row-level security policies exist
psql -c "\d users" | grep -i "check\|constraint" || echo "⚠️ Consider adding RLS policies"
```
