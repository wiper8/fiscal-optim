try_stategy <- function(age, actifs, revenus, depenses, strategy) {
  actifs_history <- matrix(
    c(actifs$cash),
    nrow = 1, ncol = 1,
    dimnames = list(NULL, c("cash"))
  )
  
  for (i in seq_len(MAX_AGE - age)) {
    revenu_disponible <- revenus$revenu_emploi[i]
    remaining_cash <- actifs_history[i, "cash"] + revenu_disponible - depenses$depenses[i]
    
    if (remaining_cash < 0) {
      message(paste0("argent insuffisant à i=", i))
    }
    
    # update les actifs
    new_actifs <- remaining_cash
    actifs_history <- rbind(
      actifs_history,
      new_actifs
    )
  }
  actifs_history
}
