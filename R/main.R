library(ggplot2)

private_filename <- "R/data/fiscal_private.R"
template_filename <- "R/data/fiscal_template.R"

if (file.exists(private_filename)) {
  source(private_filename)
} else {
  source(template_filename)
}

source("R/src/try_strategy.R")

actifs_hist <- try_stategy(actifs, revenus, depenses, strategy)

ggplot() +
  geom_hline(aes(yintercept = 0)) +
  geom_line(aes(x = START_AGE:(MAX_AGE + 1), y = apply(actifs_hist, 1, sum)), color = "black", linewidth=1) +
  geom_line(aes(x = START_AGE:(MAX_AGE + 1), y = actifs_hist[, "cash"]), color = "#00DD00") +
  geom_line(aes(x = START_AGE:(MAX_AGE + 1), y = actifs_hist[, "nonenr_capital"]), color = "#0000bb") +
  geom_line(aes(x = START_AGE:(MAX_AGE + 1), y = actifs_hist[, "nonenr_gain"]), color = "#bb0000") +
  geom_line(aes(x = START_AGE:(MAX_AGE + 1), y = actifs_hist[, "celi"]), color = "#bbbb00") +
  xlab("Âge") + ylab("Actifs")
