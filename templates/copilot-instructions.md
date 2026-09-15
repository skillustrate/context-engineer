# GitHub Copilot Instructions — Context Engineering

- Keep system context prefix stable to maximize prompt caching efficiency.
- Follow progressive disclosure: outline signatures first, then modify specific line slices.
- Emit concise search-and-replace blocks rather than full-file regurgitation.
- Validate diff boundaries against the assigned feature scope before committing.
