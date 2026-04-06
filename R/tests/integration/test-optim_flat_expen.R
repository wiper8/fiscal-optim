source("R/src/optim/maximise_expenses.R")

template_filename <- "R/data/fiscal_template.R"
source(template_filename)

maximise_expenses(start_age, max_age, data_filepath = template_filename, inflation_over_ipc = 1.02, eps = 100,
                  verbose = FALSE, limit_itr = 50)

TRUE
