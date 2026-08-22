# Topic 04 data dictionary

File: `data/topic04_synthetic.csv`; one row per fictional treatment-eligible patient.

| Variable | Type | Meaning / units |
|---|---|---|
| `patient_id` | text | Fictional unique identifier |
| `age_years` | integer | Age at eligibility, years |
| `comorbidity_count` | integer | Recorded long-term conditions |
| `baseline_severity_score` | integer | Fictional 5–95 baseline severity score |
| `healthcare_access` | categorical | High; Moderate; Low |
| `treatment_received` | categorical | Treatment; Usual care |
| `outcome_90_days` | categorical | Survived; Died |
| `synthetic` | logical | Always TRUE |

