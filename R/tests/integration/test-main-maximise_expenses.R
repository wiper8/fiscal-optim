template_filename <- "R/data/fiscal_template.R"

source(template_filename)
source("R/src/optim/maximise_expenses.R")

actifs_hist <- maximise_expenses(actifs, revenus, depenses, passed_revenus)

TRUE
