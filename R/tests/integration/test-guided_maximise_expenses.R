source("R/src/optim/guided_maximise_expenses.R")

template_filename <- "R/data/fiscal_template.R"
source(template_filename)

guided_maximise_expenses(start_age, max_age,
  data_filepath = template_filename, eps = 100,
  inflation = inflation, ipc = ipc,
  verbose = 0, limit_time = 0.25, optimiser = "swarm"
)

TRUE
