# Topic 05 data dictionary

File: `data/topic05_synthetic.csv`; one row per fictional mother–child pair.

| Variable | Type | Meaning / units |
|---|---|---|
| `child_id` | text | Fictional unique identifier |
| `maternal_age_years` | numeric | Maternal age at birth, years |
| `deprivation_quintile` | ordinal integer | 1 most deprived to 5 least deprived |
| `prenatal_exposure` | categorical | Recorded exposure; No recorded exposure |
| `preterm_birth` | categorical | Yes; No |
| `followup_age_months` | numeric | Child age at assessment; missing without follow-up |
| `developmental_support_flag` | categorical | Yes; No; missing without follow-up |
| `observed_at_followup` | categorical | Yes; No |
| `synthetic` | logical | Always TRUE |

