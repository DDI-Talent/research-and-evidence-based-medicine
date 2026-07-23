# Research and Evidence-Based Medicine

Teaching materials and a living Quarto course notebook for the University of
Edinburgh MBChB Research and Evidence-Based Medicine course.

## Repository structure

Each teaching topic has one folder:

- `S1_T01_...` to `S1_T08_...` contain Semester 1 topics.
- `S2_T09_...` to `S2_T16_...` contain Semester 2 topics.
- Each topic’s `index.qmd` is its website page. Slides, datasets, code-alongs,
  lab materials, and readings for that topic should live beside it.
- `Templates/` contains reusable teaching templates.
- `assets/` contains shared website assets.
- `_quarto.yml`, `index.qmd`, `course-guide.qmd`, `resources.qmd`, and
  `styles.scss` define the shared course website.

## Preview the website locally

```bash
quarto preview
```

## Publish

The workflow in `.github/workflows/publish.yml` renders and deploys the website
to GitHub Pages whenever changes are pushed to `main`.
