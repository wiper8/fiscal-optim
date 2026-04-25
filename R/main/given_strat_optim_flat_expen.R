source("R/src/optim/given_strat_optim_expen.R")

private_filename <- "R/data/fiscal_private.R"
template_filename <- "R/data/fiscal_template.R"


data_filename <- if (file.exists(private_filename)) {
  private_filename
} else {
  template_filename
}

given_strat_optim_expen(data_filename, strategy, inflation = inflation, ipc = ipc)
