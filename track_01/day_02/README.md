# Daten Organisation (mit Git)
Hier finden sich alle Materialen zur SpringSchool die sich mit der Organisation von Daten im Rahmen wissenschaftlicher Auswertung befassen.

## Übersicht
Erklärung einer vorgeschlagenen Verzeichnisstruktur:

```
├── data
├── results
├── scripts
    └── ana01_prepdata.R
├── src
    └── import_data.R
└── README.md
```

### Folders

- `data`: Where you put raw data for your project. You usually won't sync this to source control, unless you use very small, text-based datasets (< 10 MBs).
- `results`: Where you put results, as well as figures and tables. If these files are heavy, you won't put these under source control.
- `scripts`: Where you put scripts for data analysis.
- `src`: Where you put reusable modules/functions for your project. This is the kind of code that you `import`.

### Files
- `README.md` contains a description of your project. This file is what people see by default when they navigate to your project folder on GitHub.

##
## About
Maintained by [Julius Welzel](mailto:j.welzel@neurologie.uni-kiel.de).
