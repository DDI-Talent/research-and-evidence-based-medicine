#!/usr/bin/env Rscript

# Reproducible generators for the eight Semester 1 synthetic teaching datasets.
# Base R only. These data are fictional and must not be used for clinical care.

inv_logit <- function(x) 1 / (1 + exp(-x))
clamp <- function(x, lo, hi) pmin(pmax(x, lo), hi)
miss <- function(x, p) { x[runif(length(x)) < p] <- NA; x }
repo_root <- normalizePath(getwd(), mustWork = TRUE)

write_topic <- function(number, data) {
  dirs <- list.dirs(repo_root, recursive = FALSE, full.names = TRUE)
  hit <- dirs[grepl(sprintf("S1_T%02d_", number), basename(dirs))]
  if (length(hit) != 1) stop("Could not resolve topic directory ", number)
  out_dir <- file.path(hit, "data")
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  out <- file.path(out_dir, sprintf("topic%02d_synthetic.csv", number))
  write.csv(data, out, row.names = FALSE, na = "", quote = TRUE)
  message(sprintf("Topic %02d: %d rows -> %s", number, nrow(data), out))
  invisible(out)
}

generate_topic01 <- function() {
  set.seed(10101); n <- 1200
  age <- round(clamp(rnorm(n, 62, 17), 18, 96))
  sex <- sample(c("Female", "Male"), n, TRUE, c(.47, .53))
  deprivation_quintile <- sample(1:5, n, TRUE, c(.24, .22, .20, .18, .16))
  admission_type <- sample(c("Medical", "Emergency surgery", "Planned surgery"), n, TRUE, c(.61, .25, .14))
  diagnosis <- sample(c("Sepsis", "Respiratory failure", "Neurological", "Trauma", "Post-operative monitoring", "Other"), n, TRUE, c(.24, .22, .13, .10, .17, .14))
  comorbidity_count <- pmin(rpois(n, pmax(0.3, (age - 25) / 28)), 8)
  severity_score <- round(clamp(rnorm(n, 13 + 3*(admission_type == "Medical") + 2*(diagnosis == "Sepsis") + .12*(age-60), 6), 0, 40))
  organ_support_count <- pmin(rpois(n, exp(-.7 + .075*severity_score)), 5)
  icu_length_of_stay_days <- round(clamp(rlnorm(n, log(2.2 + .55*organ_support_count), .85), .2, 75), 1)
  mortality_p <- inv_logit(-5.2 + .10*severity_score + .018*(age-60) + .24*organ_support_count)
  hospital_outcome <- ifelse(rbinom(n, 1, mortality_p) == 1, "Died", "Discharged alive")
  hospital_length_of_stay_days <- round(clamp(icu_length_of_stay_days + rlnorm(n, log(5), .75), .5, 150), 1)
  data.frame(
    patient_id = sprintf("ICU%04d", seq_len(n)), age_years = age, sex,
    deprivation_quintile, admission_type, primary_diagnosis = diagnosis,
    comorbidity_count, severity_score, organ_support_count,
    icu_length_of_stay_days = miss(icu_length_of_stay_days, .018),
    hospital_length_of_stay_days = miss(hospital_length_of_stay_days, .025),
    hospital_outcome, synthetic = TRUE, stringsAsFactors = FALSE
  )
}

generate_topic02 <- function() {
  set.seed(20202); n <- 480
  centre <- sample(sprintf("Centre_%02d", 1:8), n, TRUE)
  trial_arm <- sample(c("Active", "Placebo"), n, TRUE)
  age <- round(clamp(rnorm(n, 59, 11), 25, 84))
  disease_duration <- round(clamp(rlnorm(n, log(15), .55), 2, 60), 1)
  baseline <- round(clamp(rnorm(n, 36 - .10*disease_duration, 5), 12, 47))
  # Higher change is better; the active arm has a modest mean benefit.
  change <- round(clamp(rnorm(n, -4.8 + 1.25*(trial_arm == "Active") - .045*(disease_duration-15), 4.8), -20, 8), 1)
  followup <- clamp(baseline + change, 0, 48)
  completed <- rbinom(n, 1, inv_logit(3.1 + .08*(followup-30)))
  data.frame(
    participant_id = sprintf("MND%04d", seq_len(n)), centre, trial_arm,
    age_years = age, disease_duration_months = disease_duration,
    baseline_function_score = baseline,
    followup_function_score = ifelse(completed == 1, followup, NA),
    change_in_function_score = ifelse(completed == 1, change, NA),
    completed_followup = ifelse(completed == 1, "Yes", "No"),
    synthetic = TRUE, stringsAsFactors = FALSE
  )
}

generate_topic03 <- function() {
  set.seed(30303); n <- 360
  strategy <- sample(c("Standard transplant", "Engraftment co-therapy", "Repeat transplant"), n, TRUE, c(.46,.34,.20))
  age <- round(clamp(rnorm(n, 45, 10), 20, 68))
  years_t1d <- round(clamp(rnorm(n, 27, 9), 5, 52), 1)
  donor_islet_equivalent <- round(clamp(rnorm(n, 8300 + 650*(strategy == "Repeat transplant"), 1500), 4500, 13000))
  graft <- round(clamp(rnorm(n, 50 + 8*(strategy == "Engraftment co-therapy") + 5*(strategy == "Repeat transplant") + .002*(donor_islet_equivalent-8000), 13), 8, 92), 1)
  hba1c <- round(clamp(74 - .31*graft + rnorm(n, 0, 5), 35, 85), 1)
  insulin <- round(clamp(46 - .48*graft + rnorm(n, 0, 6), 0, 60), 1)
  independence <- rbinom(n, 1, inv_logit(-4.1 + .075*graft))
  data.frame(
    recipient_id = sprintf("ISL%04d", seq_len(n)), transplant_strategy = strategy,
    age_years = age, years_with_type1_diabetes = years_t1d,
    donor_islet_equivalent_per_kg = donor_islet_equivalent,
    graft_function_score = graft, hba1c_mmol_mol = hba1c,
    daily_insulin_units = insulin,
    insulin_independent_at_12_months = ifelse(independence == 1, "Yes", "No"),
    synthetic = TRUE, stringsAsFactors = FALSE
  )
}

generate_topic04 <- function() {
  set.seed(40404); n <- 2500
  age <- round(clamp(rnorm(n, 66, 15), 18, 95))
  severity <- round(clamp(rnorm(n, 45 + .18*(age-60), 16), 5, 95))
  comorbidity <- pmin(rpois(n, pmax(.2, (age-30)/25)), 8)
  access <- sample(c("High", "Moderate", "Low"), n, TRUE, c(.35,.45,.20))
  treat_p <- inv_logit(-2.8 + .055*severity - .22*comorbidity + .35*(access == "High"))
  treatment <- ifelse(rbinom(n, 1, treat_p) == 1, "Treatment", "Usual care")
  # Treatment lowers individual risk, but confounding by severity makes its crude outcome look worse.
  outcome_p <- inv_logit(-5.3 + .070*severity + .26*comorbidity + .018*(age-60) - .62*(treatment == "Treatment"))
  outcome <- ifelse(rbinom(n, 1, outcome_p) == 1, "Died", "Survived")
  data.frame(
    patient_id = sprintf("RWE%05d", seq_len(n)), age_years = age,
    comorbidity_count = comorbidity, baseline_severity_score = severity,
    healthcare_access = access, treatment_received = treatment,
    outcome_90_days = outcome, synthetic = TRUE, stringsAsFactors = FALSE
  )
}

generate_topic05 <- function() {
  set.seed(50505); n <- 1800
  maternal_age <- round(clamp(rnorm(n, 31, 5.2), 17, 46), 1)
  deprivation <- sample(1:5, n, TRUE, c(.22,.21,.20,.19,.18))
  prenatal_exposure <- ifelse(rbinom(n, 1, inv_logit(-1.0 + .18*(3-deprivation))) == 1, "Recorded exposure", "No recorded exposure")
  preterm_p <- inv_logit(-3.3 + .45*(prenatal_exposure == "Recorded exposure") + .20*(3-deprivation) + .035*abs(maternal_age-30))
  preterm <- rbinom(n, 1, preterm_p)
  developmental_p <- inv_logit(-3.05 + .42*(prenatal_exposure == "Recorded exposure") + .65*preterm + .22*(3-deprivation))
  developmental <- rbinom(n, 1, developmental_p)
  followup <- round(clamp(rnorm(n, 30, 4), 22, 42), 1)
  observed <- rbinom(n, 1, inv_logit(2.7 - .24*(3-deprivation)))
  data.frame(
    child_id = sprintf("CHD%05d", seq_len(n)), maternal_age_years = maternal_age,
    deprivation_quintile = deprivation, prenatal_exposure,
    preterm_birth = ifelse(preterm == 1, "Yes", "No"),
    followup_age_months = ifelse(observed == 1, followup, NA),
    developmental_support_flag = ifelse(observed == 1, ifelse(developmental == 1, "Yes", "No"), NA),
    observed_at_followup = ifelse(observed == 1, "Yes", "No"),
    synthetic = TRUE, stringsAsFactors = FALSE
  )
}

generate_topic06 <- function() {
  set.seed(60606); n <- 2000
  me_status <- sample(c("ME", "Control"), n, TRUE)
  age <- round(clamp(rnorm(n, 47, 14), 18, 78))
  sex <- sample(c("Female", "Male"), n, TRUE, c(.68,.32))
  bmi <- round(clamp(rnorm(n, 26 + 1.0*(me_status == "ME"), 4.8), 17, 44), 1)
  activity <- round(clamp(rnorm(n, 7800 - 3900*(me_status == "ME") - 18*(age-45), 1900), 500, 15000))
  medication <- ifelse(rbinom(n, 1, inv_logit(-1.2 + .65*(me_status == "ME") + .025*(age-45))) == 1, "Yes", "No")
  biomarker <- round(clamp(rnorm(n, 48 + 8.2*(me_status == "ME") - .0011*(activity-6000) + .12*(bmi-25) + 1.2*(sex == "Female"), 7), 20, 95), 2)
  symptom <- ifelse(me_status == "ME", round(clamp(rnorm(n, 58 - .001*(activity-4000), 15), 10, 95)), NA)
  data.frame(
    participant_id = sprintf("MEC%05d", seq_len(n)), me_status, age_years = age,
    sex, bmi_kg_m2 = bmi, daily_steps = activity, regular_medication = medication,
    biomarker_concentration_au = miss(biomarker, .02), symptom_severity_score = symptom,
    synthetic = TRUE, stringsAsFactors = FALSE
  )
}

generate_topic07 <- function() {
  set.seed(70707); n <- 1600
  cohort <- sample(c("Development", "External validation"), n, TRUE, c(.72,.28))
  age <- round(clamp(rnorm(n, 67, 11), 28, 92))
  sex <- sample(c("Female", "Male"), n, TRUE)
  stage <- sample(c("II", "III", "IV"), n, TRUE, c(.35,.43,.22))
  location <- sample(c("Proximal colon", "Distal colon", "Rectum"), n, TRUE, c(.34,.36,.30))
  msi <- ifelse(rbinom(n, 1, inv_logit(-1.9 + .35*(location == "Proximal colon"))) == 1, "MSI-high", "Not MSI-high")
  apc <- sample(c("Higher residual function", "Intermediate residual function", "Lower residual function"), n, TRUE, c(.28,.49,.23))
  molecular_subtype <- sample(c("Immune", "Canonical", "Metabolic", "Mesenchymal"), n, TRUE, c(.18,.37,.20,.25))
  treatment <- sample(c("Surgery alone", "Chemotherapy", "Combined therapy"), n, TRUE, c(.25,.37,.38))
  lp <- -1.35 + .85*(stage == "III") + 1.65*(stage == "IV") + .48*(molecular_subtype == "Mesenchymal") - .42*(msi == "MSI-high") + .30*(apc == "Lower residual function") - .32*(treatment == "Combined therapy")
  progression <- rbinom(n, 1, inv_logit(lp))
  response_p <- inv_logit(.25 - .55*(stage == "IV") + .45*(msi == "MSI-high") + .35*(treatment == "Combined therapy"))
  response <- ifelse(treatment == "Surgery alone", NA, ifelse(rbinom(n, 1, response_p) == 1, "Response", "No response"))
  data.frame(
    tumour_id = sprintf("CRC%05d", seq_len(n)), cohort, age_years = age, sex,
    tumour_stage = stage, tumour_location = location, msi_status = msi,
    apc_function_group = apc, molecular_subtype, initial_treatment = treatment,
    progression_within_2_years = ifelse(progression == 1, "Yes", "No"),
    treatment_response = response, synthetic = TRUE, stringsAsFactors = FALSE
  )
}

generate_topic08 <- function() {
  set.seed(80808); n <- 2400
  region <- sample(c("North", "East", "South", "West"), n, TRUE, c(.18,.27,.31,.24))
  year <- sample(2019:2025, n, TRUE)
  age <- round(clamp(rnorm(n, 30.5, 5.5), 16, 47), 1)
  deprivation <- sample(1:5, n, TRUE, c(.22,.21,.20,.19,.18))
  baseline_risk <- inv_logit(-3.15 + .30*(3-deprivation) + .025*abs(age-30) + .22*(region == "North"))
  screened <- rbinom(n, 1, inv_logit(.55 + .09*(year-2019) + .20*(deprivation-3) - .28*(region == "North")))
  high_risk <- rbinom(n, 1, baseline_risk)
  offered <- ifelse(screened == 1 & high_risk == 1, rbinom(n, 1, .82), 0)
  accepted <- ifelse(offered == 1, rbinom(n, 1, .74), 0)
  adverse_p <- clamp(baseline_risk * ifelse(accepted == 1, .68, 1), .005, .45)
  adverse <- rbinom(n, 1, adverse_p)
  burden <- ifelse(accepted == 1, rbinom(n, 1, .11), 0)
  data.frame(
    pregnancy_id = sprintf("POP%05d", seq_len(n)), region, calendar_year = year,
    maternal_age_years = age, deprivation_quintile = deprivation,
    screening_completed = ifelse(screened == 1, "Yes", "No"),
    high_risk_screen = ifelse(screened == 1, ifelse(high_risk == 1, "Yes", "No"), NA),
    preventive_support_offered = ifelse(offered == 1, "Yes", "No"),
    preventive_support_accepted = ifelse(accepted == 1, "Yes", "No"),
    adverse_perinatal_outcome = ifelse(adverse == 1, "Yes", "No"),
    intervention_burden_reported = ifelse(burden == 1, "Yes", "No"),
    synthetic = TRUE, stringsAsFactors = FALSE
  )
}

generators <- list(generate_topic01, generate_topic02, generate_topic03, generate_topic04,
                   generate_topic05, generate_topic06, generate_topic07, generate_topic08)
args <- commandArgs(trailingOnly = TRUE)
wrapper_topic <- Sys.getenv("REBMED_TOPIC", unset = "")
selected <- if (nzchar(wrapper_topic)) as.integer(wrapper_topic) else if (length(args) == 0) 1:8 else as.integer(args)
if (any(is.na(selected)) || any(!selected %in% 1:8)) stop("Topics must be integers 1 to 8")
for (i in selected) write_topic(i, generators[[i]]())
