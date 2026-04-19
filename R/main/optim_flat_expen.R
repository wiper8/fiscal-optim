source("R/src/plot_actifs_hist.R")
source("R/src/optim/maximise_expenses.R")
source("R/src/get_flat_expenses_ipc.R")

private_filename <- "R/data/fiscal_private.R"
template_filename <- "R/data/fiscal_template.R"

data_filepath <- if (file.exists(private_filename)) {
  private_filename
} else {
  template_filename
}

source(data_filepath)

age_retraite <- revenus$age[head(which(revenus$revenu_emploi == 0), 1)]

tmp <- maximise_expenses(start_age, max_age, bloc_splits = c(age_retraite, 65), data_filepath = data_filepath, eps = 1,
                         inflation = inflation, ipc = ipc, verbose = FALSE, limit_itr = Inf, verbose_max = T)

actifs_hist <- try_strategy(
  actifs, revenus, get_flat_expenses_ipc(start_age, max_age, tmp$depenses, inflation, ipc),
  tmp$strategy, passed_revenus
)

key_moments <- c(start_age, age_retraite, 65, 71, 75, max_age)

plot_actifs_hist(actifs_hist, key_moments)
