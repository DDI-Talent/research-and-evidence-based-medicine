# Topic 07 data dictionary

File: `data/topic07_synthetic.csv`; one row per fictional colorectal tumour/patient record.

| Variable | Type | Meaning / units |
|---|---|---|
| `tumour_id` | text | Fictional unique identifier |
| `cohort` | categorical | Development; External validation |
| `age_years` | integer | Age at diagnosis, years |
| `sex` | categorical | Female; Male |
| `tumour_stage` | ordinal categorical | II; III; IV |
| `tumour_location` | categorical | Proximal colon; Distal colon; Rectum |
| `msi_status` | categorical | MSI-high; Not MSI-high |
| `apc_function_group` | categorical | Simplified fictional residual-function group |
| `molecular_subtype` | categorical | Fictional broad molecular subtype |
| `initial_treatment` | categorical | Surgery alone; Chemotherapy; Combined therapy |
| `progression_within_2_years` | categorical | Yes; No |
| `treatment_response` | categorical | Response; No response; not applicable for surgery alone |
| `synthetic` | logical | Always TRUE |

