# Topic 08 data dictionary

File: `data/topic08_synthetic.csv`; one row per fictional pregnancy.

| Variable | Type | Meaning / units |
|---|---|---|
| `pregnancy_id` | text | Fictional unique identifier |
| `region` | categorical | Fictional North; East; South; West regions |
| `calendar_year` | integer | Fictional observation year, 2019–2025 |
| `maternal_age_years` | numeric | Maternal age, years |
| `deprivation_quintile` | ordinal integer | 1 most deprived to 5 least deprived |
| `screening_completed` | categorical | Yes; No |
| `high_risk_screen` | categorical | Yes; No; missing when not screened |
| `preventive_support_offered` | categorical | Yes; No |
| `preventive_support_accepted` | categorical | Yes; No |
| `adverse_perinatal_outcome` | categorical | Yes; No; fictional composite outcome |
| `intervention_burden_reported` | categorical | Yes; No |
| `synthetic` | logical | Always TRUE |

