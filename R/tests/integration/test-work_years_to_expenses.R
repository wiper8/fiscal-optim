source("R/src/optim/work_years_to_expenses.R")

template_filename <- "R/data/fiscal_template.R"
source(template_filename)

work_years_to_expenses(template_filename, salaire, limit_itr = 15, bloc_splits = 65)

TRUE
