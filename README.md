# Harrington-all-Murder-Mystery

A fully playable, evidence-based SQL murder mystery that guides players through a structured investigation.
Each phase unlocks new datasets, encouraging deductive reasoning, timeline construction, and critical source evaluation.

### Highlights
- Multi-stage unlocking of evidence sets
- Statements, logs, CCTV metadata, ledger edit provenance, and audit trails
- Narrative designed to reward *reasoning*, not guesswork
- Built for players who like *thinking slowly and carefully*

### Files
- **murderMystery.md**  
  Main narrative and investigation phases. This is the document players read while solving.

- **murderMystery.R**  
  This script constructs all the CSV datasets used during gameplay (witness statements, uniform inventory, key cabinet logs, CCTV metadata, system audits, etc.). 
  
- **murderMysterySol.qmd**  
  Full solution walkthrough, including reasoning structure and query logic.

### How to Play
1. Start in `murderMystery.md` at **Phase 0**
2. Do **not** skip ahead. You unlock data as you reason
3. End with a **4-step evidence chain** linking specific records/timestamps

If you try it, let me know what you uncover.
