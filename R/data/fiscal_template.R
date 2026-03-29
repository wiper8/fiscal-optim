max_age <- 100 # en date du 1er janvier
inflation <- 1.0275
ipc <- 1.02
rendement_brut <- 1.07 # capital gain (excludes dividends)
dividend_yield <- 0.01 # yearly
rendement <- rendement_brut / inflation
rendement_cash <- 1.0055
start_age <- 50 # en date du 1er janvier
passed_work_years <- 25 # nombre d'années cotisées de travail avec salaire au régime de rente employeur
cotis_rente_yield1 <- 0.05 # under MGA
cotis_rente_yield2 <- 0.06 # over MGA

# en date du 1er janvier
actifs <- list(
  cash = 500000,
  nonenr_capital = 100000,
  nonenr_gain = 200000,
  celi = list(
    contrib_yearly = 7000, # droits de cotisation supplémentaires par an
    contrib_lim = 4500, # droits de cotisation
    current_value = 48000 # valeur présente du celi (capital + gain)
  )
)

# en date du 1er janvier
revenus <- data.frame(
  age = start_age:max_age,
  revenu_emploi = 0
)

# en date du 1er janvier
depenses <- data.frame(
  age = start_age:max_age,
  depenses = 40000
)

# strategy of withdrawals
strategy <- matrix(
  NA,
  nrow = 1,
  ncol = 3,
  dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI"))
)
strategy[1, "COTIS_NONENR"] <- 0
strategy[1, "SELL_NONENR"] <- 13500
strategy[1, "NET_COTIS_CELI"] <- -2175

strategy <- matrix(
  strategy,
  nrow = max_age - start_age + 1,
  ncol = ncol(strategy),
  byrow = TRUE,
  dimnames = dimnames(strategy)
)
