source("R/src/try_strategy.R")

get_bounds <- function(data_filepath, bloc_splits = NULL, ...) {
  source(data_filepath)
  depenses$depenses <- depenses$depenses * 0
  strategy <- strategy * 0

  stopifnot(all(bloc_splits <= max_age & start_age <= bloc_splits))
  ages <- unique(c(start_age, sort(bloc_splits), max_age))

  actifs_hist <- try_strategy(actifs, revenus, depenses, strategy, passed_revenus)
  
  # group by bloc splits
  groups <- matrix(
    c(
      head(ages - min(ages) + 1, -1),
      tail(ages - min(ages) + 1, -1) - 1
    ),
    ncol = 2
  )

  fake_i <- rendement + dividend_yield
  actuariat_factor <- (fake_i^groups[, 2] - 1) / (fake_i - 1)

  tmp <- apply(groups, 1, function(idx) max(actifs_hist[idx[1]:idx[2], "cash"]))
  maxes <- matrix(
    c(
      tmp, # NONENR
      tmp, # CELI
      rep(actifs$reer$plafond, length(tmp)), # REER
      (actifs$reer$droits_cotis_inutilises + actifs$reer$cotis_versees_non_deduites) * fake_i^groups[, 2] +
        actifs$reer$plafond * actuariat_factor # déduction REER
    ),
    nrow = 4,
    byrow = TRUE
  )

  tmp <- apply(groups, 1, function(idx) max(actifs_hist[idx[1]:idx[2], "cash"]))
  mins <- matrix(
    c(
      -((actifs$nonenr_capital + actifs$nonenr_gain) * fake_i^groups[, 2] + tmp * actuariat_factor),
      -(actifs$celi$current_value * fake_i^groups[, 2] + actifs$celi$contrib_yearly * actuariat_factor),
      -((actifs$reer$current_value +
           actifs$reer$droits_cotis_inutilises +
           actifs$reer$cotis_versees_non_deduites
         ) * fake_i^groups[, 2] + actifs$reer$plafond * actuariat_factor),
      rep(0, nrow(groups))
    ),
    nrow = 4,
    byrow = TRUE
  )

  list(
    lower = mins,
    upper = maxes
  )
}
