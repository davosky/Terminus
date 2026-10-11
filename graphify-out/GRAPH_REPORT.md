# Graph Report - Terminus  (2026-10-11)

## Corpus Check
- 83 files · ~66,894 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 287 nodes · 231 edges · 76 communities (52 shown, 24 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 4 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `1ee5e0ff`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 51|Community 51]]
- [[_COMMUNITY_Community 52|Community 52]]
- [[_COMMUNITY_Community 56|Community 56]]
- [[_COMMUNITY_Community 57|Community 57]]
- [[_COMMUNITY_Community 59|Community 59]]
- [[_COMMUNITY_Community 60|Community 60]]
- [[_COMMUNITY_Community 61|Community 61]]
- [[_COMMUNITY_Community 62|Community 62]]
- [[_COMMUNITY_Community 67|Community 67]]
- [[_COMMUNITY_Community 68|Community 68]]
- [[_COMMUNITY_Community 69|Community 69]]
- [[_COMMUNITY_Community 70|Community 70]]
- [[_COMMUNITY_Community 71|Community 71]]
- [[_COMMUNITY_Community 72|Community 72]]

## God Nodes (most connected - your core abstractions)
1. `CLAUDE.md — Guida per Claude Code` - 25 edges
2. `VehiclesController` - 11 edges
3. `TransportsController` - 11 edges
4. `ApplicationPolicy` - 9 edges
5. `Best Practice di Sicurezza Chiave in Ruby on Rails` - 9 edges
6. `TransportPolicy` - 8 edges
7. `7. Autenticazione e Autorizzazione Robuste` - 7 edges
8. `OwnedRecordPolicy` - 6 edges
9. `Installazione e Utilizzo bundler-audit` - 6 edges
10. `UserCodeField` - 5 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Communities (76 total, 24 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.05
Nodes (38): 1. Pensare prima di scrivere codice, 2. Prima la semplicità, 3. Modifiche chirurgiche, 4. Esecuzione orientata all'obiettivo, ❌ Anti-Pattern da Evitare, 🗃️ Applicazione, Approfondimento: bundler-audit, 🔑 Best Practice Essenziali di Sicurezza per Ruby on Rails (+30 more)

### Community 1 - "Community 1"
Cohesion: 0.08
Nodes (26): 1. Protezione dall'SQL Injection, 2. Mitigazione del Cross-Site Scripting (XSS), 3. Gestione Sicura di Segreti, Credenziali e Dati di Configurazione Sensibili, 4. Corretta Gestione delle Sessioni e Cookie Sicuri, 5. Strategie di Protezione contro il Cross-Site Request Forgery (CSRF), 6. Upload di File Sicuri e Gestione degli Allegati, 8. Monitoraggio e Audit di Sicurezza Continui, Best Practice di Sicurezza Chiave in Ruby on Rails (+18 more)

### Community 3 - "Community 3"
Cohesion: 0.22
Nodes (8): Applicazione WEB scritta in Ruby On Rails per gestire rimborsi spese ed assenze, Controllo visuale, Database, Interfaccia, Logica dell'applicazione, Proporzioni, Struttura di User, Terminus

### Community 4 - "Community 4"
Cohesion: 0.29
Nodes (7): 7. Autenticazione e Autorizzazione Robuste, code:ruby, code:ruby, code:ruby, code:ruby, code:ruby, code:ruby

### Community 7 - "Community 7"
Cohesion: 0.40
Nodes (5): Approccio: Test-first quando possibile, code:bash (spec/), code:ruby (# Esempio factory minima), Regole per i Test, 🧪 Testing

### Community 8 - "Community 8"
Cohesion: 0.40
Nodes (5): Controller, 🤝 Convenzioni di Codice, Generale, Modelli, Naming

### Community 9 - "Community 9"
Cohesion: 0.40
Nodes (5): Approfondimento: Brakeman, code:ruby, code:bash, code:ruby, Installazione e Utilizzo

### Community 10 - "Community 10"
Cohesion: 0.22
Nodes (8): Applicazione WEB scritta in Ruby On Rails per gestire rimborsi spese ed assenze, Controllo visuale, Database, Interfaccia, Logica dell'applicazione, Proporzioni, Struttura di User, Terminus

### Community 14 - "Community 14"
Cohesion: 0.17
Nodes (3): UserCodeField, User, UserResource

### Community 22 - "Community 22"
Cohesion: 0.29
Nodes (6): Avvio del progetto, code:bash (bin/setup   # setup iniziale (dipendenze, database)), Licenza, README, Stack tecnico, Terminus

### Community 51 - "Community 51"
Cohesion: 0.40
Nodes (4): Copyright (c) 2026, Davo Davosky - The Davosky Connection, English, Italiano

## Knowledge Gaps
- **85 isolated node(s):** `Application`, `VehiclePolicy`, `application`, `ApplicationRecord`, `Transport` (+80 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **24 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `CLAUDE.md — Guida per Claude Code` connect `Community 0` to `Community 8`, `Community 1`, `Community 9`, `Community 7`?**
  _High betweenness centrality (0.075) - this node is a cross-community bridge._
- **Why does `Best Practice di Sicurezza Chiave in Ruby on Rails` connect `Community 1` to `Community 0`, `Community 4`?**
  _High betweenness centrality (0.053) - this node is a cross-community bridge._
- **Why does `7. Autenticazione e Autorizzazione Robuste` connect `Community 4` to `Community 1`?**
  _High betweenness centrality (0.012) - this node is a cross-community bridge._
- **What connects `Application`, `VehiclePolicy`, `application` to the rest of the system?**
  _85 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.05128205128205128 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.07692307692307693 - nodes in this community are weakly interconnected._