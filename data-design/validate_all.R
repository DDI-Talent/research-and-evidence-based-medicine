#!/usr/bin/env Rscript

repo_root <- normalizePath(getwd(), mustWork = TRUE)
dirs <- list.dirs(repo_root, recursive = FALSE, full.names = TRUE)
report <- character()
add <- function(...) report <<- c(report, paste0(...))

expected_rows <- c(1200, 480, 360, 2500, 1800, 2000, 1600, 2400)
id_columns <- c("patient_id", "participant_id", "recipient_id", "patient_id",
                "child_id", "participant_id", "tumour_id", "pregnancy_id")

add("# Synthetic dataset validation report", "\n")
add("Generated: ", format(Sys.time(), "%Y-%m-%d %H:%M %Z"), "\n")

for (i in 1:8) {
  hit <- dirs[grepl(sprintf("S1_T%02d_", i), basename(dirs))]
  path <- file.path(hit, "data", sprintf("topic%02d_synthetic.csv", i))
  d <- read.csv(path, stringsAsFactors = FALSE, na.strings = "")
  checks <- c(
    rows = nrow(d) == expected_rows[i],
    unique_identifier = length(unique(d[[id_columns[i]]])) == nrow(d),
    unique_names = !anyDuplicated(names(d)),
    snake_case_names = all(grepl("^[a-z][a-z0-9_]*$", names(d))),
    synthetic_marker = all(d$synthetic)
  )
  add("## Topic ", sprintf("%02d", i), "\n")
  add("- File: `", file.path(basename(hit), "data", basename(path)), "`\n")
  add("- Dimensions: ", nrow(d), " rows x ", ncol(d), " columns\n")
  add("- Structural checks: ", if (all(checks)) "PASS" else "FAIL", "\n")
  if (!all(checks)) add("- Failed: ", paste(names(checks)[!checks], collapse = ", "), "\n")

  substantive_ok <- TRUE
  signal <- switch(as.character(i),
    `1` = sprintf("Median ICU stay %.1f days; mean %.1f days (right-skew expected).", median(d$icu_length_of_stay_days, na.rm=TRUE), mean(d$icu_length_of_stay_days, na.rm=TRUE)),
    `2` = { m <- aggregate(change_in_function_score ~ trial_arm, d, mean, na.rm=TRUE); paste(apply(m,1,paste,collapse=" = "), collapse="; ") },
    `3` = { m <- aggregate(graft_function_score ~ transplant_strategy, d, mean); paste(apply(m,1,paste,collapse=" = "), collapse="; ") },
    `4` = {
      crude <- prop.table(table(d$treatment_received, d$outcome_90_days),1)[,"Died"]
      fit <- glm(I(outcome_90_days == "Died") ~ treatment_received + baseline_severity_score + age_years + comorbidity_count, data=d, family=binomial())
      adjusted_or <- exp(coef(fit)["treatment_receivedUsual care"])
      substantive_ok <- crude["Treatment"] > crude["Usual care"] && adjusted_or > 1
      paste("Crude mortality:", paste(names(crude), round(crude,3), collapse="; "), sprintf("; adjusted OR for usual care vs treatment %.2f.", adjusted_or))
    },
    `5` = { r <- prop.table(table(d$prenatal_exposure, d$developmental_support_flag),1)[,"Yes"]; paste("Observed developmental-support risk:", paste(names(r), round(r,3), collapse="; ")) },
    `6` = { m <- aggregate(biomarker_concentration_au ~ me_status, d, mean, na.rm=TRUE); paste(apply(m,1,paste,collapse=" = "), collapse="; ") },
    `7` = { r <- prop.table(table(d$cohort, d$progression_within_2_years),1)[,"Yes"]; paste("Progression prevalence:", paste(names(r), round(r,3), collapse="; ")) },
    `8` = { r <- prop.table(table(d$screening_completed, d$adverse_perinatal_outcome),1)[,"Yes"]; paste("Observed outcome risk by screening:", paste(names(r), round(r,3), collapse="; ")) }
  )
  add("- Teaching signal: ", signal, "\n\n")
  if (!substantive_ok) stop("Substantive teaching-signal check failed for topic ", i)
}

out <- file.path(repo_root, "data-design", "validation-report.md")
writeLines(report, out)
message("Wrote ", out)
