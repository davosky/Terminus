# Graph Report - Terminus  (2026-10-10)

## Corpus Check
- 55 files · ~35,334 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 175 nodes · 133 edges · 51 communities (40 shown, 11 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

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

## God Nodes (most connected - your core abstractions)
1. `CLAUDE.md — Guida per Claude Code` - 25 edges
2. `ApplicationPolicy` - 9 edges
3. `Best Practice di Sicurezza Chiave in Ruby on Rails` - 9 edges
4. `7. Autenticazione e Autorizzazione Robuste` - 7 edges
5. `Installazione e Utilizzo bundler-audit` - 6 edges
6. `🤝 Convenzioni di Codice` - 5 edges
7. `3. Gestione Sicura di Segreti, Credenziali e Dati di Configurazione Sensibili` - 5 edges
8. `6. Upload di File Sicuri e Gestione degli Allegati` - 5 edges
9. `2. Mitigazione del Cross-Site Scripting (XSS)` - 4 edges
10. `4. Corretta Gestione delle Sessioni e Cookie Sicuri` - 4 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Communities (51 total, 11 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.06
Nodes (31): 1. Pensare prima di scrivere codice, 2. Prima la semplicità, 3. Modifiche chirurgiche, 4. Esecuzione orientata all'obiettivo, ❌ Anti-Pattern da Evitare, 🗃️ Applicazione, 🔑 Best Practice Essenziali di Sicurezza per Ruby on Rails, Checklist delle Best Practice di Sicurezza (+23 more)

### Community 1 - "Community 1"
Cohesion: 0.10
Nodes (21): 1. Protezione dall'SQL Injection, 2. Mitigazione del Cross-Site Scripting (XSS), 4. Corretta Gestione delle Sessioni e Cookie Sicuri, 5. Strategie di Protezione contro il Cross-Site Request Forgery (CSRF), 6. Upload di File Sicuri e Gestione degli Allegati, 8. Monitoraggio e Audit di Sicurezza Continui, Best Practice di Sicurezza Chiave in Ruby on Rails, code:ruby (+13 more)

### Community 3 - "Community 3"
Cohesion: 0.22
Nodes (8): Applicazione WEB scritta in Ruby On Rails per gestire rimborsi spese ed assenze, Controllo visuale, Database, Interfaccia, Logica dell'applicazione, Proporzioni, Struttura di User, Terminus

### Community 4 - "Community 4"
Cohesion: 0.29
Nodes (7): 7. Autenticazione e Autorizzazione Robuste, code:ruby, code:ruby, code:ruby, code:ruby, code:ruby, code:ruby

### Community 5 - "Community 5"
Cohesion: 0.29
Nodes (7): Approfondimento: bundler-audit, code:ruby, code:bash, code:ruby, code:ruby, code:ruby, Installazione e Utilizzo bundler-audit

### Community 6 - "Community 6"
Cohesion: 0.40
Nodes (5): 3. Gestione Sicura di Segreti, Credenziali e Dati di Configurazione Sensibili, code:ruby, code:ruby, code:ruby, code:ruby

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

## Knowledge Gaps
- **75 isolated node(s):** `Application`, `application`, `ApplicationRecord`, `ApplicationJob`, `ApplicationMailer` (+70 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **11 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `CLAUDE.md — Guida per Claude Code` connect `Community 0` to `Community 1`, `Community 5`, `Community 7`, `Community 8`, `Community 9`?**
  _High betweenness centrality (0.204) - this node is a cross-community bridge._
- **Why does `Best Practice di Sicurezza Chiave in Ruby on Rails` connect `Community 1` to `Community 0`, `Community 4`, `Community 6`?**
  _High betweenness centrality (0.144) - this node is a cross-community bridge._
- **Why does `7. Autenticazione e Autorizzazione Robuste` connect `Community 4` to `Community 1`?**
  _High betweenness centrality (0.033) - this node is a cross-community bridge._
- **What connects `Application`, `application`, `ApplicationRecord` to the rest of the system?**
  _75 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.0625 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.09523809523809523 - nodes in this community are weakly interconnected._