source("R/src/optim/maximise_expenses.R")

template_filename <- "R/data/fiscal_template.R"
source(template_filename)

maximise_expenses(start_age, max_age, data_filepath = template_filename, eps = 100, inflation = inflation, ipc = ipc,
                  verbose = FALSE, limit_itr = 40)

TRUE
