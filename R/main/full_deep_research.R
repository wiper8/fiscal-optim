source("R/src/plot_work_years_expenses.R")
source("R/src/optim/work_years_to_expenses.R")
source("R/src/optim/mandatory_work_years.R")

private_filename <- "R/data/fiscal_private.R"
template_filename <- "R/data/fiscal_template.R"

data_filepath <- if (file.exists(private_filename)) {
  private_filename
} else {
  template_filename
}

source(data_filepath)

age_retraite <- revenus$age[head(which(revenus$revenu_emploi == 0), 1)]

tmp <- guided_maximise_expenses(
  start_age, max_age, data_filepath = data_filepath, inflation = inflation, ipc = ipc,
  bloc_splits = c(35, 45, 55, 65, 71, 75, 80, 85, 90, 95),
  eps = 10, verbose = 4, limit_time = 120
)

actifs_hist <- try_strategy(
  actifs, revenus, get_expenses_ipc(start_age, max_age, tmp$depenses + depenses_variables$depenses, inflation, ipc),
  tmp$strategy, passed_revenus,
  start_age, max_age
)

key_moments <- c(start_age, age_retraite, 65, 71, 75, max_age)

plot_actifs_hist(actifs_hist, key_moments)

###

df2 <- work_years_to_expenses(data_filepath, salaire,
                              limit_time = 120,
                              method = "guided_maximise",
                              bloc_splits = c(30, 35, 40, 45, 50, 55, 65, 71, 75, 80, 85, 90, 95),
                              verbose = 4
)

plot_work_years_expenses(df2)

mandatory_work_years(df2, total_expenses = depenses[1, "depenses"])
mandatory_work_years(df2, additional_expenses = 1000, current_expenses = depenses[1, "depenses"])
