# RobynTest

Purpose: provide a reproducible Robyn demo script that runs on macOS (R 4.5.2, Apple Silicon).

## Files
- `code-robyn-demo.R` — end-to-end Robyn demo script using built-in sample data.
- `run.R` — convenience wrapper that sources `code-robyn-demo.R`.
- `sessionInfo.txt` — full R session info from the original report.
- `error_log.txt` — historical console errors kept for reference.

## Repro steps
1. Open R or RStudio in this project.
2. Install Robyn if necessary: `install.packages("Robyn")`.
3. Run `source("run.R")` (or source `code-robyn-demo.R` directly).

## Expected outcome
- The Robyn demo runs with the packaged demo data and writes outputs to the working directory.
