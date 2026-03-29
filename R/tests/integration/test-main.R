template_filename <- "R/data/fiscal_template.R"

source(template_filename)
source("R/src/try_strategy.R")

actifs_hist <- try_stategy(actifs, revenus, depenses, strategy)

TRUE
