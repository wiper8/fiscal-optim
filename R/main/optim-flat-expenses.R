library(ggplot2)
library(scales)

source("R/src/optim/optim_flat_expenses.R")

private_filename <- "R/data/fiscal_private.R"
template_filename <- "R/data/fiscal_template.R"


data_filename <- if (file.exists(private_filename)) {
  private_filename
} else {
  template_filename
}

optim_flat_expenses(data_filename, inflation, eps = 100)
