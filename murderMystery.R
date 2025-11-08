cat("\014")
rm(list = ls())

suppressPackageStartupMessages({
  library(dplyr)
  library(tibble)
  library(stringr)
  library(lubridate)
  library(randomNames)
  library(tidyr)
  library(purrr)
})

set.seed(1234)

# output path
desktop_path <- "~/Desktop/"

# === TIME HELPERS ===
tz_local <- "UTC"

rand_times <- function(n, start, end) {
  # generate numeric times and convert
  raw <- runif(n, as.numeric(as.POSIXct(start, tz = tz_local)),
               as.numeric(as.POSIXct(end, tz = tz_local)))
  format(as.POSIXct(raw, tz = tz_local), "%Y-%m-%d %H:%M:%S")
}

# people
staff <- tribble(
  ~person_id, ~full_name,           ~role,
  1,          "Edwin Hale",          "Butler",
  2,          "Miriam Lowe",         "Head Housekeeper",
  3,          "Tess Reed",           "Junior Maid",
  4,          "Ada Finch",           "Maid",
  5,          "Rosalie Trent",       "Maid",
  6,          "Graham Cole",         "Groundskeeper",
  7,          "Mr. Hartwell",        "Cook",
  8,          "Jonas Bell",          "Driver",
  9,          "Miles Carter",        "Senior Guard",
  10,         "Eton Briggs",         "Junior Guard"
)

guests <- tribble(
  ~person_id, ~full_name,         ~role,
  11,         "Sir Malcolm Pierce", "Guest",
  12,         "Ivy Park",           "Guest",
  13,         "Thomas Welles",      "Guest",
  14,         "Dr. Clara Fenwick",  "Guest",
  15,         "Dorian Harrington",  "Guest",
  16,         "Lady Selene Graye",  "Guest",
  17,         "Felix March",        "Guest",
  18,         "Rowan Pierce",       "Guest"
)

filler <- tibble(
  person_id = 19:30,
  full_name = randomNames(12),
  role = sample(c("Staff","Guest"), 12, TRUE, prob=c(0.7,0.3))
)

people <- bind_rows(staff, guests, filler) %>% arrange(person_id)
write.csv(people, file.path(desktop_path,"people.csv"), row.names=FALSE)

# writing reports
voices <- list(
  "Edwin Hale" = c(
    "The household was in rhythm; any disruption would have passed through me.",
    "Sir Malcolm kept to the library near ten; his composure was affected but controlled.",
    "Order is the solvent of panic. I applied it where needed."
  ),
  "Miriam Lowe" = c(
    "No maid had leave for the service landing during turndown.",
    "Closet keys are issued, recorded, and returned. If the door opened, a key was used.",
    "Tess folded linens in the east wing; she did not stray from her list."
  ),
  "Tess Reed" = c(
    "I returned apron TR-04 after dinner; it was stained earlier.",
    "I was in the kitchen past nine; the stock pot needed watching.",
    "I avoid the service landing unless I am told otherwise."
  ),
  "Ada Finch" = c(
    "Tess isn’t built to lie. Frighten her and she tells you everything.",
    "If someone wanted a neat suspect, they chose the girl with initials on an apron.",
    "I checked the laundry carts at twenty-one-hundred; counts were clean."
  ),
  "Rosalie Trent" = c(
    "A figure moved by the landing rail, but the lamps stuttered.",
    "I heard hurried steps on the back stair and then quiet, the kind that listens.",
    "Sometimes fear looks exactly like guilt when you glance too quickly."
  ),
  "Graham Cole" = c(
    "I walked the orchard path until my head cooled.",
    "He could make you feel small without lifting a finger.",
    "Pride is a poor alibi but it is mine."
  )
)

fallback <- c(
  "I was at my post.",
  "If something happened then, I did not witness it.",
  "Time does not move cleanly at night."
)

witness_reports <- tibble(
  report_id = 1:70,
  person_id = sample(people$person_id,70,TRUE),
  timestamp = rand_times(70,"2025-11-06 18:00:00","2025-11-07 03:00:00")
) %>%
  left_join(people, by="person_id") %>%
  rowwise() %>%
  mutate(statement = {
    v <- voices[[full_name]]
    if(is.null(v)) sample(fallback,1) else sample(v,1)
  }) %>%
  ungroup() %>%
  arrange(timestamp, report_id)

write.csv(witness_reports,file.path(desktop_path,"witness_reports.csv"),row.names=FALSE)

# cleaning tools
cleaning_logs <- tibble(
  log_id = 1:60,
  area = sample(c("linen_closet","kitchen","east_hall","west_stair"),60,TRUE),
  checked_at = rand_times(60,"2025-11-06 09:00:00","2025-11-07 20:00:00"),
  smell_report = sample(c("none","faint","normal","strong"),60,TRUE)
)

cleaning_logs <- bind_rows(
  cleaning_logs,
  tribble(
    ~log_id, ~area, ~checked_at,            ~smell_report,
    61, "linen_closet", "2025-11-06 21:40:00", "none",
    62, "linen_closet", "2025-11-07 08:10:00", "faint",
    63, "linen_closet", "2025-11-07 19:30:00", "strong"
  )
) %>% arrange(checked_at)

write.csv(cleaning_logs,file.path(desktop_path,"cleaning_logs.csv"),row.names=FALSE)

# uniforms
inventory_uniforms <- tibble(
  apron_id = paste0("TR-",sprintf("%02d",1:60)),
  assigned_to = sample(people$person_id,60,TRUE),
  status = sample(c("in_use","laundry","returned"),60,TRUE),
  last_updated = rand_times(60,"2025-11-06 08:00:00","2025-11-07 23:30:00")
) %>%
  mutate(
    assigned_to = ifelse(apron_id=="TR-04",3,assigned_to),
    status      = ifelse(apron_id=="TR-04","returned",status),
    last_updated = ifelse(apron_id=="TR-04","2025-11-06 20:45:00",last_updated)
  )

write.csv(inventory_uniforms,file.path(desktop_path,"inventory_uniforms.csv"),row.names=FALSE)

# household ledger
ledger_text <- c(
  "Silver inventory reconciled — pantry shelf three",
  "Dining sconces rewired; flicker persists",
  "Kitchen coal delivery recorded",
  "Visitor hamper assembled",
  "Linen count verified in east wing",
  "Boiler pressure check nominal",
  "Garden tools returned chipped",
  "Pantry lock lubricated",
  "Roof gutter cleared",
  "Bulb stock replenished"
)

ledger <- tibble(
  entry_id = 1:60,
  author_id = sample(people$person_id,60,TRUE),
  created_at = rand_times(60,"2025-11-06 18:00:00","2025-11-07 04:00:00"),
  last_edited_at = NA_character_,
  editor_id = NA_integer_,
  description = sample(ledger_text,60,TRUE),
  revert_flag = sample(c(0,0,0,1),60,TRUE),
  edit_provenance = "CHK_SHA256:ok"
)

ledger <- bind_rows(
  ledger,
  tribble(
    ~entry_id, ~author_id, ~created_at,             ~last_edited_at,        ~editor_id, ~description,                                        ~revert_flag, ~edit_provenance,
    501,        3,          "2025-11-06 22:38:00",  "2025-11-07 03:58:30", 1,           "Linen transfer — see note (T.R.)",                   1,            "ADMIN_OVERRIDE:console-2",
    512,       14,          "2025-11-06 22:19:00",  NA,                    NA,          "Ether bottle replaced in medical kit drawer",        0,            "CHK_SHA256:ok",
    527,       14,          "2025-11-06 22:28:00",  "2025-11-07 03:58:30", 1,           "Sedative stock adjusted — late request",             1,            "LEGACY_MD5:suspect"
  )
)

write.csv(ledger,file.path(desktop_path,"household_ledger.csv"),row.names=FALSE)

# cctv
cams <- c("service_hall","kitchen_cam","east_corridor","west_entry","back_stairs")

cctv_metadata <- tibble(
  clip_id = 1:60,
  cam_name = sample(cams,60,TRUE),
  start_time = rand_times(60,"2025-11-06 21:00:00","2025-11-07 02:00:00"),
  duration = sample(c(60,90,120,150),60,TRUE)
) %>%
  mutate(
    end_time = as.POSIXct(start_time, tz=tz_local) + duration,
    end_time = format(end_time, "%Y-%m-%d %H:%M:%S"),
    faces_detected = map_chr(1:n(), ~ paste(sample(people$full_name, sample(0:3,1)), collapse=", ")),
    verified_by = sample(c(people$person_id, NA), n(),TRUE),
    archived_copy = FALSE,
    hash_algorithm = "sha256",
    hash_code = paste0("VH_", stringi::stri_rand_strings(n(),8,'[A-Za-z0-9]'))
  )

cctv_metadata <- bind_rows(
  cctv_metadata,
  tribble(
    ~clip_id, ~cam_name,      ~start_time,              ~end_time,                ~faces_detected,         ~verified_by, ~archived_copy, ~hash_algorithm, ~hash_code,
    201,      "service_hall", "2025-11-06 22:14:00",   "2025-11-06 22:16:00",   "Tess Reed",             NA,          TRUE,            "md5",           "ARCH_9f2b1c3a",
    202,      "kitchen_cam",  "2025-11-06 22:14:00",   "2025-11-06 22:16:00",   "Tess Reed, Mr. Hartwell", 9,         FALSE,           "sha256",        "VH_a4b3d9c2"
  )
)

write.csv(cctv_metadata,file.path(desktop_path,"cctv_metadata.csv"),row.names=FALSE)

# key cabinet log (physical key sign-out records) ===
# Only 3 keys matter in the narrative:
# closet_key_2 gets signed out at 22:05 by Edwin Hale (butler)

key_cabinet_log <- tribble(
  ~record_id, ~key_name,       ~signed_out_by, ~signed_out_at,
  1,         "closet_key_1",   2,              "2025-11-06 19:20:00",   # Miriam routine use
  2,         "closet_key_2",   1,              "2025-11-06 22:05:00",   # <-- The critical clue (Edwin)
  3,         "tool_shed_key",  6,              "2025-11-06 21:10:00",   # Graham outdoors
  4,         "pantry_key",     7,              "2025-11-06 21:50:00"    # Hartwell normal workflow
)

write.csv(key_cabinet_log, file.path(desktop_path, "key_cabinet_log.csv"), row.names = FALSE)


# system audit
detail_phrases <- c(
  "session OK","login accepted","no anomalies",
  "checksum verified","background sync","auto-log rotation","archive indexed"
)

system_audit <- tibble(
  audit_id = 1:60,
  user_id = sample(people$person_id,60,TRUE),
  action = sample(c("edit_ledger","export_cctv_archive","badge_checkout","login"),60,TRUE),
  timestamp = rand_times(60,"2025-11-06 23:00:00","2025-11-07 05:00:00"),
  details = sample(detail_phrases,60,TRUE)
)

system_audit <- bind_rows(
  system_audit,
  tribble(
    ~audit_id, ~user_id, ~action,             ~timestamp,           ~details,
    901,       1,        "export_cctv_archive","2025-11-07 03:55:02","exported clip 201 to archive",
    902,       1,        "edit_ledger",        "2025-11-07 03:58:30","edited entry 501 metadata"
  )
)

write.csv(system_audit,file.path(desktop_path,"system_audit.csv"),row.names=FALSE)


# round 2 witness statements

# Make sure iso() exists:
iso <- function(x) format(with_tz(x, tzone = tz_local), "%Y-%m-%d %H:%M:%S")

# round 2 timestamps every 3 minutes starting at 22:40
round2_time_start <- ymd_hms("2025-11-07 22:40:00", tz = tz_local)
round2_times <- function(n) {
  iso(seq(from = round2_time_start, by = "3 min", length.out = n))
}

round2_statements <- tribble(
  ~full_name,            ~statement,
  "Tess Reed",           "I said I was in the kitchen because I was. I only went near the service hall because I heard the plates shift. You think I don’t know how this looks? I didn’t hurt him. I just did what I was told.",
  "Mr. Hartwell",        "Don't drag her into this. The girl was stirring soup under my eye. I told her to step away for five minutes. If something happened then, it happened faster than a thought.",
  "Edwin Hale",          "Order was slipping. I restored it. If I adjusted records, I did so because they were incorrect. You are mistaking clarity for deceit.",
  "Miriam Lowe",         "Keys do not wander. People do. The closet key was signed out. I know who used it. Duty is not guilt.",
  "Eton Briggs",         "Yes, I left my post. I heard footsteps when I came back. I didn't follow. I should have. I thought it wasn’t my business.",
  "Miles Carter",        "The camera feeds don’t lie. Clip 202 is real. The question is why someone wanted 201 gone. And you already know who had the access.",
  "Dr. Clara Fenwick",   "He came to me shaking. I adjusted the sedatives. I did not administer them. Mercy is not a crime.",
  "Ada Finch",           "This house eats the gentle first. You’re circling Tess because she’s easy prey. If you want the truth — look at who cleaned up afterwards.",
  "Rosalie Trent",       "I saw a shadow, not a face. But the shape was tall. Tess is small. I didn’t want to say it, but I don’t know anymore.",
  "Dorian Harrington",   "He enjoyed making people feel small. Someone was going to break. I just didn’t expect it so soon."
)

witness_reports_round2 <- round2_statements %>%
  left_join(people, by = "full_name") %>%
  mutate(
    report_id = 200 + row_number(),
    timestamp = round2_times(n())
  ) %>%
  select(report_id, person_id, timestamp, statement)

write.csv(
  witness_reports_round2,
  file.path(desktop_path, "witness_reports_round2.csv"),
  row.names = FALSE
)

message("✔ Round 2 witness report CSV written.")


# writing final reveal file

ending_text <- "
# Final Reveal at Harrington Hall 

The person who physically committed the killing was **Edwin Hale**, the butler.
But the person who **shaped the conditions**, **guided the emotional pressure**, 
and ensured the decision felt *necessary* was **Lady Selene Graye**.

Edwin acted with his hands, but Selene acted with her influence.

## The Evidence of the Act: Edwin Hale

The evidence shows that while the surface narrative initially pointed to Tess Reed, the physical actions that shaped 
the crime all trace back to Edwin Hale. The apron TR-04, which supposedly incriminated Tess, had in fact been returned
to the linen closet at 20:45. For it to appear again near the service hall at 22:14, someone would have had to retrieve 
it deliberately,and Tess did not have access. The linen-closet key needed to retrieve that apron, closet_key_2, was checked
out at 22:05, and the record shows it was signed out by Edwin Hale. Meanwhile, the CCTV system provides the most telling 
contrast: Clip 202, showing Tess in the kitchen at 22:14, is fully verified. But Clip 201, which should have shown the service 
hall at that same moment, is the only clip in the entire archive marked archived_copy = TRUE, using an MD5 hash instead of the 
standard SHA256, indicating tampering. And at 03:55, the system audit records Edwin exporting that exact clip. Three minutes later,
at 03:58, Edwin edits ledger entry 501, altering the written account of who handled the linens and when, shifting suspicion onto Tess.
These are not the actions of someone reacting in fear — they are the deliberate steps of someone constructing a version of events. 
Edwin retrieved the apron, moved the body, tampered with the surveillance, and rewrote the ledger. He is not guessing, improvising, 
or panicking. He is shaping the narrative.

## The Evidence of Influence: Lady Selene Graye

Selene never signs out a key, edits a ledger, or touches a CCTV archive, yet multiple witness accounts describe her presence as quietly
authoritative, the kind of presence that does not argue but sets reality. She speaks of order not as preference, but as duty — and of 
disruption as something that must be removed to preserve the whole. Tess is described, in her words and in others', as fragile, a weak point
in the house’s structure; Edwin, in contrast, is someone she frames as the keeper of stability. Her language does not instruct; it reshapes 
belief: “Some disruptions cannot be endured.” “Mercy becomes cruelty when it invites collapse.” “The house must be kept whole.” Selene never 
needed to tell Edwin to act, she simply defined the terms under which the choice became inevitable. Edwin did not kill out of impulse or anger.
He killed because he came to believe that protecting the house was necessary. And that belief did not originate with him. Selene didn’t move the
body, she moved the thought that made the murder possible.
"

writeLines(ending_text, file.path(desktop_path, "ENDING_REVEAL.md"))
message("✔ NEW ENDING_REVEAL.md (Version B) written to Desktop")

message("✔ Reveal file created at: ", normalizePath(file.path(desktop_path, "ENDING_REVEAL.md")))


message("✔ ALL CSVs SUCCESSFULLY WRITTEN to ", normalizePath(desktop_path))

