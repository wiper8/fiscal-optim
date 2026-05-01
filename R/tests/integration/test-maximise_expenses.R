source("R/src/optim/maximise_expenses.R")

template_filename <- "R/data/fiscal_template.R"
source(template_filename)

maximise_expenses(start_age, max_age,
  data_filepath = template_filename, eps = 100, inflation = inflation, ipc = ipc,
  verbose = 0, limit_time = 0.25
)

# tester le feature bloc_splits
maximise_expenses(start_age, max_age,
  data_filepath = template_filename, eps = 100, inflation = inflation, ipc = ipc,
  verbose = 0, limit_time = 0.25, bloc_splits = c(65, 71)
)

TRUE
