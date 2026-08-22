# Topic 03 data dictionary

File: `data/topic03_synthetic.csv`; one row per fictional transplant recipient.

| Variable | Type | Meaning / units |
|---|---|---|
| `recipient_id` | text | Fictional unique identifier |
| `transplant_strategy` | categorical | Standard; fictional co-therapy; repeat transplant |
| `age_years` | integer | Age at transplant, years |
| `years_with_type1_diabetes` | numeric | Duration of type 1 diabetes, years |
| `donor_islet_equivalent_per_kg` | integer | Fictional transplanted islet-equivalent dose per kg |
| `graft_function_score` | numeric | Fictional 0–100 score; higher is better |
| `hba1c_mmol_mol` | numeric | HbA1c, mmol/mol |
| `daily_insulin_units` | numeric | Exogenous insulin, units/day |
| `insulin_independent_at_12_months` | categorical | Yes; No |
| `synthetic` | logical | Always TRUE |

