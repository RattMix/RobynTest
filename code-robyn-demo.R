# code-robyn-demo.R — reproducible Robyn demo script

suppressPackageStartupMessages(library(Robyn))

# Load built-in demo data -------------------------------------------------------
if (!exists("dt_simulated_weekly")) data("dt_simulated_weekly")
if (!exists("dt_prophet_holidays")) data("dt_prophet_holidays")

dataset_cols <- names(dt_simulated_weekly)

paid_media_spends <- intersect(
  c("tv_S", "ooh_S", "print_S", "search_S", "facebook_S"),
  dataset_cols
)
paid_media_vars <- paid_media_spends
context_vars <- intersect("competitor_sales_B", dataset_cols)

if (length(paid_media_spends) == 0) {
  stop("No paid media spend columns were found in dt_simulated_weekly.")
}

# Hyperparameter grid -----------------------------------------------------------
channel_hypers <- list()
for (channel in paid_media_spends) {
  channel_hypers[[sprintf("%s_thetas", channel)]] <- c(0, 0.9)
  channel_hypers[[sprintf("%s_alphas", channel)]] <- c(0.1, 3)
  channel_hypers[[sprintf("%s_gammas", channel)]] <- c(0.3, 1)
}

hyperparameters <- c(
  channel_hypers,
  list(
    lambda     = c(0, 0.1),
    train_size = c(0.5, 0.8)
  )
)

# Build input object ------------------------------------------------------------
InputCollect <- robyn_inputs(
  dt_input          = dt_simulated_weekly,
  dt_holidays       = dt_prophet_holidays,
  date_var          = "DATE",
  dep_var           = "revenue",
  dep_var_type      = "revenue",
  prophet_vars      = c("trend", "season", "weekday", "holiday"),
  prophet_country   = "GB",
  paid_media_vars   = paid_media_vars,
  paid_media_spends = paid_media_spends,
  context_vars      = context_vars,
  adstock           = "geometric"
)

InputCollect$hyperparameters <- hyperparameters

# Run a lightweight model -------------------------------------------------------
model <- robyn_run(
  robyn_object = InputCollect,
  trials       = 3,
  iterations   = 200,
  cores        = max(1, parallel::detectCores(logical = FALSE) - 1)
)

# Summarise results -------------------------------------------------------------
outputs <- robyn_outputs(model)
print(outputs$summary)
robyn_write(outputs, dir = getwd())

message("Robyn demo completed successfully.")
