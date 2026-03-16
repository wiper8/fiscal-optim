source("R/src/manage_nonenr.R")
source("R/src/get_revenu_disponible.R")

try_stategy <- function(actifs, revenus, depenses, strategy) {
  actifs_history <- matrix(
    c(actifs$nonenr_capital, actifs$nonenr_gain, actifs$cash),
    nrow = 1,
    dimnames = list(NULL, c("nonenr_capital", "nonenr_gain", "cash"))
  )
  
  for (i in seq_len(MAX_AGE - START_AGE)) {
    
    nonenr_capital <- tail(actifs_history[, "nonenr_capital"], 1)
    nonenr_gain <- tail(actifs_history[, "nonenr_gain"], 1)
    
    new_nonenr <- manage_nonenr(nonenr_capital, nonenr_gain, strategy[i, ], share_price = RENDEMENT^(i - 1))
    
    revenu_disponible <- get_revenu_disponible(
      revenus$revenu_emploi[i],
      new_nonenr$capital_vendu,
      new_nonenr$gain_en_capital_vendu,
      age = START_AGE + i - 1
    )
    
    remaining_cash <- actifs_history[i, "cash"] + revenu_disponible - depenses$depenses[i]
    
    if (remaining_cash < 0) {
      message(paste0("argent insuffisant à i=", i))
    }
    
    # update les actifs
    new_actifs <- c(
      "nonenr_capital" = nonenr_capital - new_nonenr$capital_vendu,
      "nonenr_gain" = nonenr_gain - new_nonenr$gain_en_capital_vendu,
      "cash" = remaining_cash
    )
    names(new_actifs) <- c("nonenr_capital", "nonenr_gain", "cash")

    # appliquer du rendement
    new_actifs <- c(
      new_actifs["nonenr_capital"],
      (new_actifs["nonenr_gain"] + new_actifs["nonenr_capital"]) * RENDEMENT - new_actifs["nonenr_capital"],
      remaining_cash
    )

    actifs_history <- rbind(
      actifs_history,
      new_actifs
    )
  }
  actifs_history
}
