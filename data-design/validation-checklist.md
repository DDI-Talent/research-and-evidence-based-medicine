# Dataset validation checklist

For every released dataset:

- [ ] Generator runs in a clean R session with base R only.
- [ ] Re-running produces a byte-identical CSV.
- [ ] Row count and unique identifier count agree.
- [ ] Variable names are unique and use `snake_case`.
- [ ] Categorical values match the data dictionary.
- [ ] Units, missingness and derived variables are documented.
- [ ] Numeric values fall within the generator's plausibility bounds.
- [ ] The intended teaching signal appears in the validation report.
- [ ] No real identifiers, dates of birth, postcodes or free text are present.
- [ ] The contributor has approved the clinical framing and attribution.
- [ ] The student script states that the data and results are synthetic.

