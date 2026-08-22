# Semester 1 synthetic teaching datasets

This directory defines the common design and governance conventions for the
Topic 01–08 code-along datasets. The released CSV files are **synthetic**:
they contain no participant records and do not reproduce published results.

## Design principles

1. Each row has a clearly stated unit of observation.
2. Identifiers are fictional and contain no embedded personal information.
3. Variables use `snake_case`; missing values are written as blank CSV cells.
4. Units and coding are documented in the topic data dictionary.
5. Each generator uses a fixed seed and base R only.
6. Each dataset contains a visible teaching signal and at least one limitation.
7. Clinical values are plausible enough for teaching, but are not suitable for
   clinical care, service planning, or scientific inference.

## Rebuild all datasets

From the repository root:

```bash
Rscript data-design/generate_all.R
Rscript data-design/validate_all.R
```

Each topic also contains a small `data-generation/generate_topicNN.R` wrapper
that rebuilds only that topic's CSV.

## Code-along notebooks

Each Topic 01–08 directory contains two R Markdown notebooks:

- `code-along.Rmd` is the student-facing version. It imports the topic data,
  supplies runnable scaffolding, and marks live coding tasks with `TODO`.
- `code-along-model-solutions.Rmd` is the instructor version. It contains a
  complete analysis and model clinical interpretation. Keep this file out of
  student-facing downloads until solutions are meant to be released.

Both versions render independently from their topic directory. To check one:

```r
rmarkdown::render("S1_T01_DescribingData/code-along-model-solutions.Rmd")
```

## Intended progression

| Topic | Contributor inspiration | Main analytical move |
|---|---|---|
| 01 | Nazir Lone — critical-care epidemiology | Describe patients and distributions |
| 02 | Suvankar Pal — MND trials and registries | Quantify sampling uncertainty |
| 03 | Shareen Forbes — islet transplantation | Compare clinically relevant groups |
| 04 | Sjoerd Beentjes — causal real-world evidence | Separate association from causation |
| 05 | Bonnie Auyeung — CHILDS | Calculate and communicate risk |
| 06 | Chris Ponting — ME/DecodeME | Compare crude and adjusted regression |
| 07 | Nathalie Feeley — colorectal cancer genomics | Evaluate prediction on unseen data |
| 08 | Clara Calvert — population maternal/child health | Turn risks into transparent decisions |
