source("R/src/plot_actifs_hist.R")
source("R/src/optim/maximise_expenses.R")

private_filename <- "R/data/fiscal_private.R"
template_filename <- "R/data/fiscal_template.R"

data_filepath <- if (file.exists(private_filename)) {
  private_filename
} else {
  template_filename
}

source(data_filepath)

tmp <- maximise_expenses(start_age, max_age, data_filepath = data_filepath, inflation_over_ipc = inflation, eps = 100,
                         verbose = FALSE)

actifs_hist <- try_strategy(actifs, revenus, tmp$depenses, tmp$strategy, passed_revenus)

key_moments <- c(start_age, revenus$age[head(which(revenus$revenu_emploi == 0), 1)], 65, 75, max_age)

plot_actifs_hist(actifs_hist, key_moments)
