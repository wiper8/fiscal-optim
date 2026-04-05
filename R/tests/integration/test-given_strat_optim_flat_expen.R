template_filename <- "R/data/fiscal_template.R"
source(template_filename)

source("R/src/optim/given_strat_optim_flat_expen.R")

given_strat_optim_flat_expen(template_filename, inflation, eps = 100)

TRUE
