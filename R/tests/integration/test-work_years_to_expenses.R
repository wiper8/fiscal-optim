source("R/src/optim/work_years_to_expenses.R")

template_filename <- "R/data/fiscal_template.R"
source(template_filename)

# test whether override bloc_splits works
work_years_to_expenses(template_filename, salaire, limit_time = 0.05, bloc_splits = NULL)

# test whether override work_years works
work_years_to_expenses(template_filename, salaire, limit_time = 0.05, work_years = c(0, 5))

TRUE
