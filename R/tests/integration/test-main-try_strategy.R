template_filename <- "R/data/fiscal_template.R"
source(template_filename)

source("R/src/try_strategy.R")

actifs_hist <- try_strategy(actifs, revenus, depenses, strategy, passed_revenus, start_age, max_age)

TRUE
