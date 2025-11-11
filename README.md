# RobynTest

# RobynTest

Purpose: reproduce and fix a failing Robyn demo run on macOS (R 4.5.2, Apple Silicon).

## Files
- `robyn_demo.R` — script that currently fails.
- `sessionInfo.txt` — full R session info.
- `error_log.txt` — raw console errors from RStudio.

## Repro steps
1. Open RStudio.
2. Install Robyn: `install.packages("Robyn")`
3. Run `robyn_demo.R` end-to-end.

## Expected vs actual
- Expected: model runs with demo data and produces outputs.
- Actual: hyperparameter validation errors from `robyn_inputs()` / `robyn_run()`.

## Environment
- macOS (Apple Silicon)
- R 4.5.2
- Robyn 3.12.1 from CRAN
- reticulate installed; nevergrad available

## Ask
- Make `robyn_demo.R` run cleanly with Robyn 3.12.1 using demo data.
- Keep code simple; no external data; no dev branch dependencies.
