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

df <- work_years_to_expenses(data_filepath, salaire, limit_itr = 1000,
                             bloc_splits = c(30, 35, 40, 45, 50, 55, 65, 71, 75, 80, 85, 90, 95))

plot_work_years_expenses(df)

mandatory_work_years(df, total_expenses = depenses[1, "depenses"])
mandatory_work_years(df, additional_expenses = 1000, current_expenses = depenses[1, "depenses"])
