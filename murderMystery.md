# Harrington Hall

A sprawling country manor in England, isolated by fog, yews, and a long gravel drive to wrought-iron gates. The owner, Lord Harrington, is mostly abroad. The household runs without him because it has Edwin Hale.

## The Cast

#### Household Staff
**Edwin Hale (Butler)**  
Soft-spoken, disciplined, controls the house’s rhythm and routines.

**Miriam Lowe (Head Housekeeper)**  
Precise, maintains order as a moral duty.

**Tess Reed (Junior Maid)**  
Young, anxious, eager to please, easily cornered.

**Ada Finch (Maid)**  
Protective, sharp-eyed, loyal to Tess.

**Rosalie Trent (Maid)**  
Sensitive, perceives emotion more than fact.

**Graham Cole (Groundskeeper)**  
Strong, private, prideful.

**Mr. Hartwell (Cook)**  
Quiet, reads people by movement and sound.

**Jonas Bell (Driver)**  
Reserved, briefly off-estate Saturday night.

#### Security
**Miles Carter (Senior Guard)** — Meticulous, procedures-oriented.  
**Eton Briggs (Junior Guard)** — Too agreeable, too easily swayed.

#### Guests
**Sir Malcolm Pierce (Victim)** — Collects personal weaknesses quietly.  
**Ivy Park** — Composed, restrained anger.  
**Thomas Welles** — Charming, lies to avoid silence.  
**Dr. Clara Fenwick** — Family physician, strained calm.  
**Dorian Harrington** — Restless charm covering hollowness.  
**Lady Selene Graye** — Names truths others avoid.  
**Felix March** — Observes social dynamics, collects stories.  
**Rowan Pierce** — Emotional, volatile, hurting.

---

# How to Play

Your task is to determine:
1. Who killed Sir Malcolm.
2. A four-point chain of evidence referencing specific fields/rows in the records.

Your reasoning must rely on actual **record correlations**, not vibes or guesses.

You unlock datasets in phases.  
Do **not** skip ahead.  
Each new unlock corresponds to new reasoning territory.


## Phase 0: Starting Information

#### Files Available
- `people.csv`
- `witness_reports.csv`

#### Your Job
- Identify **roles** and **hierarchies** (who can access what).
- Identify **certainty vs ambiguity** in statements.

#### Suggested Queries
- JOIN `witness_reports` to `people` → read statements by name.
- ORDER BY `timestamp` → build scene timeline.


## Phase 1: The Apron and the Closet

#### New Files Unlocked
- `cleaning_logs.csv`
- `inventory_uniforms.csv`

#### Key Questions
- Track **linen_closet smell_report** timeline. When does “strong” begin?
- Check apron **TR-04**: assigned_to? last_updated? status?
- Could this apron have been **planted**?

#### Useful SQL Moves
- WHERE area = 'linen_closet'
- ORDER BY checked_at
- WHERE apron_id = 'TR-04'

---

## Phase 2: Ledger and Key Control

#### New Files Unlocked
- `household_ledger.csv`
- `key_cabinet_log.csv`

#### Key Questions
- Who signed out **closet_key_2** around the critical time?
- Who **authored** vs **edited** ledger entry **501**?
- What does the **edit_provenance** suggest?

#### Useful SQL Moves
- WHERE key_name = 'closet_key_2'
- JOIN ledger ↔ people
- ORDER BY created_at or last_edited_at


## Phase 3: CCTV Conflict

#### New File Unlocked
- `cctv_metadata.csv`

#### Key Questions
- Who is **verified** in the kitchen at **22:14**?
- Is there a **concurrent** clip in the **service hall**?
- Which clip has **archived_copy = TRUE** or different **hash_algorithm**?

#### Useful SQL Moves
- WHERE start_time BETWEEN '22:10' AND '22:20'
- GROUP BY verified_by, archived_copy
- ORDER BY start_time


### Phase 4: Administrative Footprints

#### New File Unlocked
- `system_audit.csv`

#### Key Questions
- Who performed `export_cctv_archive`?
- Which clip was exported?
- Who edited ledger entry 501, and how soon afterward?

#### Useful SQL Moves
- JOIN system_audit ↔ people
- ORDER BY timestamp
- Compare timestamps to ledger edits


## Phase 5: Optional Round-Two Statements

#### If Using
- `witness_reports_round2.csv`

#### Objective
- Identify which statements align, deflect, or shift blame once **records** are known.


## Phase 6: Final Answer

Your final answer must include:

**1. The culprit.**  
**2. A four-step evidence chain** drawn from different tables.

Your evidence chain must show:
- A contradiction or inconsistency in physical/recorded evidence.
- A link involving access or authority.
- A timeline alignment between separate data sources.
- An action that conceals, alters, or reshapes the narrative.

**Your chain *must reference actual fields and timestamps from the data.***
Do **not** describe in general terms, point to the rows that prove it.


## Endgame

Once your group believes they have the correct chain of reasoning, open:

**`ENDING_REVEAL.md`**

This contains the final draw-room confrontation scene.



