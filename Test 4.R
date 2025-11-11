# robyn_demo.R — minimal demo that runs on Robyn 3.12.1

suppressPackageStartupMessages(library(Robyn))

# Load built-in demo data
if (!exists("dt_simulated_weekly")) data("dt_simulated_weekly")
if (!exists("dt_prophet_holidays")) data("dt_prophet_holidays")

# Select columns that exist in the demo data
paid_media_spends <- intersect(
  c("tv_S", "ooh_S", "print_S", "search_S", "facebook_S"),
  names(dt_simulated_weekly)
)
context_vars <- intersect(
  "competitor_sales_B",
  names(dt_simulated_weekly)
)

# Create channel-level hyperparameters
channel_hypers <- list()
for (ch in paid_media_spends) {
  channel_hypers[[sprintf("%s_thetas", ch)]] <- c(0, 0.9)
  channel_hypers[[sprintf("%s_alphas", ch)]] <- c(0.1, 3)
  channel_hypers[[sprintf("%s_gammas", ch)]] <- c(0.3, 1)
}

hyperparameters <- c(
  channel_hypers,
  list(
    lambda     = c(0, 0.1),
    train_size = c(0.5, 0.8)
  )
)

# Build inputs
inputs <- robyn_inputs(
  dt_input          = dt_simulated_weekly,
  dt_holidays       = dt_prophet_holidays,
  date_var          = "DATE",
  dep_var           = "revenue",
  dep_var_type      = "revenue",
  prophet_vars      = c("trend", "season", "weekday", "holiday"),
  prophet_country   = "GB",
  paid_media_spends = paid_media_spends,
  context_vars      = context_vars,
  adstock           = "geometric",
  hyperparameters   = hyperparameters
)

# Run a small test model
model <- robyn_run(
  robyn_object = inputs,
  trials       = 3,
  iterations   = 200,
  cores        = max(1, parallel::detectCores(logical = FALSE) - 1)
)

# Collect and print outputs
out <- robyn_outputs(model)
print(out$summary)
robyn_write(out, dir = getwd())
message("Robyn demo completed successfully.")
