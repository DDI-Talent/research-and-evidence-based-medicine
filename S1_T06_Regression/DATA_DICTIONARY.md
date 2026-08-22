# Topic 06 data dictionary

File: `data/topic06_synthetic.csv`; one row per fictional case-control participant.

| Variable | Type | Meaning / units |
|---|---|---|
| `participant_id` | text | Fictional unique identifier |
| `me_status` | categorical | ME; Control |
| `age_years` | integer | Age at assessment, years |
| `sex` | categorical | Female; Male |
| `bmi_kg_m2` | numeric | Body mass index, kg/m² |
| `daily_steps` | integer | Fictional average daily steps |
| `regular_medication` | categorical | Yes; No |
| `biomarker_concentration_au` | numeric | Fictional biomarker, arbitrary units; some missing |
| `symptom_severity_score` | integer | Fictional 0–100 score for ME participants only |
| `synthetic` | logical | Always TRUE |

