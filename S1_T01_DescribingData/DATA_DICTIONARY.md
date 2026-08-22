# Topic 01 data dictionary

File: `data/topic01_synthetic.csv`; one row per fictional ICU admission.

| Variable | Type | Meaning / units |
|---|---|---|
| `patient_id` | text | Fictional unique admission identifier |
| `age_years` | integer | Age at admission, years |
| `sex` | categorical | Female; Male |
| `deprivation_quintile` | ordinal integer | 1 most deprived to 5 least deprived |
| `admission_type` | categorical | Medical; Emergency surgery; Planned surgery |
| `primary_diagnosis` | categorical | Broad fictional admission category |
| `comorbidity_count` | integer | Count of recorded long-term conditions |
| `severity_score` | integer | Fictional 0–40 acute severity score; higher is more severe |
| `organ_support_count` | integer | Number of organ-support modalities, 0–5 |
| `icu_length_of_stay_days` | numeric | ICU stay in days; some missing values |
| `hospital_length_of_stay_days` | numeric | Total hospital stay in days; some missing values |
| `hospital_outcome` | categorical | Discharged alive; Died |
| `synthetic` | logical | Always TRUE |

