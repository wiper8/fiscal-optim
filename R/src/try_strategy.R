source("R/src/get_prest_psv.R")
source("R/src/manage_nonenr.R")
source("R/src/get_revenu_disponible.R")

# tenter une strategie de décaissement et tester si l'argent est suffisant
try_stategy <- function(actifs, revenus, depenses, strategy) {
  actifs_names <- c("nonenr_capital", "nonenr_gain", "cash", "celi")
  actifs_history <- matrix(
    c(actifs$nonenr_capital, actifs$nonenr_gain, actifs$cash, actifs$celi$current_value),
    nrow = 1,
    dimnames = list(NULL, actifs_names)
  )

  # itérer à chaque année, au 1er janvier.
  for (i in seq_len(max_age - start_age + 1)) {
    # changer la part de capital et de gain selon les achats et ventes
    new_nonenr <- manage_nonenr(
      tail(actifs_history[, "nonenr_capital"], 1),
      tail(actifs_history[, "nonenr_gain"], 1),
      strategy[i, "COTIS_NONENR"],
      strategy[i, "SELL_NONENR"]
    )

    # celi : contribution, retraits, nouveaux droits
    actifs$celi$contrib_lim <- actifs$celi$contrib_lim + actifs$celi$contrib_yearly - strategy[i, "NET_COTIS_CELI"]
    if (actifs$celi$contrib_lim < 0) stop("attention, droits de cotisations au celi dépassés")
    actifs$celi$current_value <- actifs$celi$current_value + strategy[i, "NET_COTIS_CELI"]

    dividendes_recus <- (new_nonenr$new_actifs$nonenr_capital + new_nonenr$new_actifs$nonenr_gain) * dividend_yield
    interet_recu <- tail(actifs_history[, "cash"], 1) * (rendement_cash - 1)

    # revenu après impôts
    revenu_disponible <- get_revenu_disponible(
      revenus$revenu_emploi[i],
      new_nonenr$capital_vendu,
      new_nonenr$gain_en_capital_vendu,
      dividendes_recus,
      interet_recu,
      pension_psv = get_prest_psv(start_age + i - 1),
      age = start_age + i - 1
    )

    remaining_cash <- actifs_history[i, "cash"] + revenu_disponible - depenses$depenses[i] -
      strategy[i, "NET_COTIS_CELI"] - strategy[i, "COTIS_NONENR"] + strategy[i, "SELL_NONENR"]

    if (remaining_cash < 0) stop(paste0("argent insuffisant à i=", i))

    # update les actifs
    new_actifs <- c(
      "nonenr_capital" = new_nonenr$new_actifs$nonenr_capital,
      "nonenr_gain" = new_nonenr$new_actifs$nonenr_gain,
      "cash" = remaining_cash,
      "celi" = actifs$celi$current_value
    )
    names(new_actifs) <- actifs_names

    # appliquer du rendement
    actifs$celi$current_value <- actifs$celi$current_value * rendement
    new_actifs <- c(
      new_actifs["nonenr_capital"],
      (new_actifs["nonenr_gain"] + new_actifs["nonenr_capital"]) * rendement - new_actifs["nonenr_capital"],
      remaining_cash * rendement_cash / ipc, 
      new_actifs["celi"] * rendement
    )
    names(new_actifs) <- actifs_names

    actifs_history <- rbind(
      actifs_history,
      new_actifs
    )
  }
  actifs_history
}
