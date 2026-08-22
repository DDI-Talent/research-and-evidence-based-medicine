# Topic 02 data dictionary

File: `data/topic02_synthetic.csv`; one row per fictional trial participant.

| Variable | Type | Meaning / units |
|---|---|---|
| `participant_id` | text | Fictional unique identifier |
| `centre` | categorical | Fictional recruitment centre |
| `trial_arm` | categorical | Active; Placebo |
| `age_years` | integer | Age at enrolment, years |
| `disease_duration_months` | numeric | Time since diagnosis, months |
| `baseline_function_score` | integer | Fictional 0–48 scale; higher is better function |
| `followup_function_score` | numeric | Follow-up score; missing if not completed |
| `change_in_function_score` | numeric | Follow-up minus baseline; higher is better |
| `completed_followup` | categorical | Yes; No |
| `synthetic` | logical | Always TRUE |

