source("R/src/try_strategy.R")
source("R/src/plot_actifs_hist.R")

private_filename <- "R/data/fiscal_private.R"
template_filename <- "R/data/fiscal_template.R"

if (file.exists(private_filename)) {
  source(private_filename)
} else {
  source(template_filename)
}

actifs_hist <- try_strategy(actifs, revenus, depenses, strategy, passed_revenus)

key_moments <- c(start_age, revenus$age[head(which(revenus$revenu_emploi == 0), 1)], 65, 71, 75, max_age)

plot_actifs_hist(actifs_hist, key_moments)
