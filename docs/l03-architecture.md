# Architecture and process (AZ-400 L03)

GitHub renders Mermaid diagrams in Markdown with a fenced `mermaid` code block.

## Request flow

```mermaid
flowchart LR
  Client -->|GET /price| Server[src/server.js]
  Server --> Pricing[src/pricing.js]
  Server -->|/health| Probe[Health probe]
```

## GitHub Flow used in this repo

```mermaid
gitGraph
  commit id: "main"
  branch l01/fix-negative-qty
  commit id: "fix: reject negative qty"
  checkout main
  merge l01/fix-negative-qty id: "PR #7 (Fixes #3)"
```

## Issue lifecycle in the L01 Project

```mermaid
stateDiagram-v2
  [*] --> Todo: Item added to project
  Todo --> InProgress
  InProgress --> Done: Item closed / PR merged
  Done --> [*]
```
