template_filename <- "R/data/fiscal_template.R"
source(template_filename)

source("R/src/optim/given_strat_optim_expen.R")

given_strat_optim_expen(template_filename, strategy, eps = 100, verbose = 0, inflation = inflation, ipc = ipc)

TRUE
