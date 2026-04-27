source("R/src/get_rente.R")
source("R/src/get_prest_psv.R")
source("R/src/manage_nonenr.R")
source("R/src/get_cotis_rrq.R")
source("R/src/get_prest_rrq.R")
source("R/src/get_droits_reer.R")
source("R/src/retrait_min_ferr.R")
source("R/src/impot/fed/annexe_7.R")
source("R/src/get_revenu_disponible.R")

# tenter une strategie de décaissement et tester si l'argent est suffisant
try_strategy <- function(actifs, revenus, depenses, strategy, passed_revenus, start_age, max_age) {
  actifs_names <- c("nonenr_capital", "nonenr_gain", "cash", "celi", "reer")
  actifs_history <- matrix(
    c(actifs$nonenr_capital, actifs$nonenr_gain, actifs$cash, actifs$celi$current_value, actifs$reer$current_value),
    nrow = 1,
    dimnames = list(NULL, actifs_names)
  )

  # itérer à chaque année, au 1er janvier.
  for (i in seq_len(max_age - start_age + 1)) {
    # changer la part de capital et de gain selon les achats et ventes
    dispo_nonenr <- sum(c(
      max(0, strategy[i, "NET_COTIS_NONENR"]), actifs_history[nrow(actifs_history), c("nonenr_capital", "nonenr_gain")]
    ))
    if (-strategy[i, "NET_COTIS_NONENR"] > dispo_nonenr) {
      warning("attention, retraits trop importants dans le NONENR")
      strategy[i, "NET_COTIS_NONENR"] <- -(dispo_nonenr - 0.01)
    }
    new_nonenr <- manage_nonenr(
      tail(actifs_history[, "nonenr_capital"], 1),
      tail(actifs_history[, "nonenr_gain"], 1),
      max(0, strategy[i, "NET_COTIS_NONENR"]),
      -min(0, strategy[i, "NET_COTIS_NONENR"])
    )

    # celi : contribution, retraits, nouveaux droits
    if (strategy[i, "NET_COTIS_CELI"] < -actifs$celi$current_value) {
      warning("attention, retraits trop importants dans le CELI")
      strategy[i, "NET_COTIS_CELI"] <- -(actifs$celi$current_value - 0.01)
    }
    if ((actifs$celi$contrib_lim + actifs$celi$contrib_yearly) < strategy[i, "NET_COTIS_CELI"]) {
      warning("attention, cotisations trop importantes dans le CELI")
      strategy[i, "NET_COTIS_CELI"] <- actifs$celi$contrib_lim + actifs$celi$contrib_yearly - 0.01
    }
    actifs$celi$contrib_lim <- actifs$celi$contrib_lim + actifs$celi$contrib_yearly - strategy[i, "NET_COTIS_CELI"]
    actifs$celi$current_value <- actifs$celi$current_value + strategy[i, "NET_COTIS_CELI"]

    # reer
    # car FERR
    if (start_age + i - 1 >= 71 && strategy[i, "NET_COTIS_REER"] > 0) {
      warning("Pas le droit de cotiser au REER, car FERR. Limité à 0.")
      strategy[i, "NET_COTIS_REER"] <- 0
    }
    if (-min(0, strategy[i, "NET_COTIS_REER"]) < (retrait_min_ferr(start_age + i - 1) * actifs$reer$current_value)) {
      warning("Retraits du REER insuffisants car FERR. Retrait forcé")
      strategy[i, "NET_COTIS_REER"] <- -(retrait_min_ferr(start_age + i - 1) * actifs$reer$current_value)
    }

    if (strategy[i, "NET_COTIS_REER"] < -actifs$reer$current_value) {
      warning("attention, retraits trop importants dans le REER.")
      strategy[i, "NET_COTIS_REER"] <- -pmax(0, actifs$reer$current_value - 0.01)
    }
    # trop de cotisation
    if (strategy[i, "DEDUCE_REER"] < 0) {
      warning("attention, déductions REER négatives impossibles")
      strategy[i, "DEDUCE_REER"] <- 0
    }
    if (strategy[i, "NET_COTIS_REER"] > actifs$reer$droits_cotis_inutilises) {
      warning("attention, droits de cotisations au reer dépassés")
      strategy[i, "NET_COTIS_REER"] <- pmax(0, actifs$reer$droits_cotis_inutilises - 0.01)
    }
    tmp_reer <- annexe_7(
      actifs$reer$cotis_versees_non_deduites,
      strategy[i, "NET_COTIS_REER"],
      strategy[i, "DEDUCE_REER"],
      actifs$reer$droits_cotis_inutilises
    )
    actifs$reer$droits_cotis_inutilises <- actifs$reer$droits_cotis_inutilises - max(0, strategy[i, "NET_COTIS_REER"]) +
      get_droits_reer(revenus$revenu_emploi[i], age = start_age + i - 1, ipc = ipc)
    actifs$reer$cotis_versees_non_deduites <- tmp_reer$cotis_inutil_vers_disp_deduc
    actifs$reer$current_value <- actifs$reer$current_value + strategy[i, "NET_COTIS_REER"]

    dividendes_recus <- (new_nonenr$new_actifs$nonenr_capital + new_nonenr$new_actifs$nonenr_gain) * dividend_yield
    interet_recu <- tail(actifs_history[, "cash"], 1) * (rendement_cash - 1)

    # revenu après impôts
    revenu_disponible <- get_revenu_disponible(
      revenus$revenu_emploi[i],
      new_nonenr$capital_vendu,
      new_nonenr$gain_en_capital_vendu,
      max(0, -strategy[i, "NET_COTIS_REER"]), # retrait REER
      l20800 = tmp_reer$l20800, # déduction REER
      dividendes_recus,
      interet_recu,
      rente_emploi = get_rente(start_age + i - 1, revenus$revenu_emploi, passed_work_years, ipc),
      pension_psv = get_prest_psv(start_age + i - 1),
      prestation_rrq = get_prest_rrq(
        c(
          passed_revenus$revenu_emploi[18 <= passed_revenus$age & passed_revenus$age < 65],
          revenus$revenu_emploi[18 <= revenus$age & revenus$age < 65]
        ),
        start_age + i - 1,
        as.numeric(format(Sys.Date(), "%Y")) + i - 1,
        ipc
      ),
      age = start_age + i - 1
    )

    remaining_cash <- actifs_history[i, "cash"] + revenu_disponible - depenses$depenses[i] -
      strategy[i, "NET_COTIS_CELI"] - strategy[i, "NET_COTIS_REER"] - max(0, strategy[i, "NET_COTIS_NONENR"])

    if (remaining_cash < 0) {
      return(paste0("argent insuffisant à i=", i))
    }

    # update les actifs
    new_actifs <- c(
      "nonenr_capital" = new_nonenr$new_actifs$nonenr_capital,
      "nonenr_gain" = new_nonenr$new_actifs$nonenr_gain,
      "cash" = remaining_cash,
      "celi" = actifs$celi$current_value,
      "reer" = actifs$reer$current_value
    )
    names(new_actifs) <- actifs_names

    # appliquer du rendement
    actifs$celi$current_value <- actifs$celi$current_value * (rendement + dividend_yield)
    actifs$reer$current_value <- actifs$reer$current_value * (rendement + dividend_yield)

    new_actifs <- c(
      new_actifs["nonenr_capital"],
      (new_actifs["nonenr_gain"] + new_actifs["nonenr_capital"]) * rendement - new_actifs["nonenr_capital"],
      remaining_cash * rendement_cash / ipc,
      new_actifs["celi"] * (rendement + dividend_yield),
      new_actifs["reer"] * (rendement + dividend_yield)
    )
    names(new_actifs) <- actifs_names

    actifs_history <- rbind(
      actifs_history,
      new_actifs
    )
  }

  actifs_history
}
