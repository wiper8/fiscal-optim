library(ggplot2)

private_filename <- "R/data/fiscal_private.R"
template_filename <- "R/data/fiscal_template.R"

if (file.exists(private_filename)) {
  source(private_filename)
} else {
  source(template_filename)
}

source("R/src/try_strategy.R")

actifs_hist <- try_stategy(START_AGE, actifs, revenus, depenses, strategy)

ggplot() +
  geom_hline(aes(yintercept = 0)) +
  geom_line(aes(x = START_AGE:MAX_AGE, y = actifs_hist[, "cash"]), color = "#00DD00") +
  xlab("Âge") + ylab("Actifs")
