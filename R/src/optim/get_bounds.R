source("R/src/try_strategy.R")

get_bounds <- function(data_filepath, ages = NULL, ...) {
  source(data_filepath)
  depenses$depenses <- depenses$depenses * 0 # si je ne dépense rien, je pourrais cotiser plus (bornes max)
  strategy <- strategy * 0 # reset la stratégie pour ne rien cotiser

  actifs_hist <- try_strategy(actifs, revenus, depenses, strategy, passed_revenus, start_age, max_age)

  # group by bloc splits
  groups <- matrix(
    c(
      head(ages - min(ages) + 1, -1),
      # TODO ajuster les bornes? ne fonctionne pas si start_age = 25, max_age = 25
      tail(ages - min(ages) + 1, -1) - 1
    ),
    ncol = 2
  )

  fake_i <- rendement + dividend_yield
  actuariat_factor <- (fake_i^groups[, 2] - 1) / (fake_i - 1)

  tmp <- apply(groups, 1, function(idx) max(actifs_hist[idx[1]:idx[2], "cash"]) / (diff(idx) + 1))
  maxes <- matrix(
    c(
      # ça suppose que si je sors de l'argent, je pourrais ne pas pouvoir le réinvestir à cause de ces bornes
      tmp, # NONENR
      rep(actifs$celi$contrib_lim + actifs$celi$contrib_yearly, length(tmp)), # CELI
      rep(actifs$reer$plafond, length(tmp)), # REER
      ((actifs$reer$droits_cotis_inutilises + actifs$reer$cotis_versees_non_deduites) * fake_i^groups[, 2] +
         actifs$reer$plafond * actuariat_factor) / (1 + apply(groups, 1, diff)) # déduction REER
    ),
    nrow = 4,
    byrow = TRUE
  )

  mins <- matrix(
    c(
      -((actifs$nonenr_capital + actifs$nonenr_gain) * fake_i^groups[, 2] +
          tmp * actuariat_factor) / (1 + apply(groups, 1, diff)),
      -(actifs$celi$current_value * fake_i^groups[, 2] +
          actifs$celi$contrib_yearly * actuariat_factor) / (1 + apply(groups, 1, diff)),
      -((
        actifs$reer$current_value +
          actifs$reer$droits_cotis_inutilises +
          actifs$reer$cotis_versees_non_deduites
      ) * fake_i^groups[, 2] + actifs$reer$plafond * actuariat_factor) / (1 + apply(groups, 1, diff)),
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

# TODO retirer test
data_filepath <- "R/data/fiscal_private.R"
real_revenus <- data.frame(age=25, revenu_emploi=104700)
real_depenses <- data.frame(age=25, depenses=25704)
real_strategy <- matrix(
  c(
    0, 0, 0, 0
  ), ncol = 4,
  dimnames = list(NULL, c("NET_COTIS_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER")),
  byrow = TRUE
)
subset = 1
ages = c(25, 100)

get_guided_bounds <- function(data_filepath, real_revenus, real_depenses, real_strategy, subset, ages = NULL) {
  source(data_filepath)
  # overwrite default param in data file
  revenus <- real_revenus
  depenses <- real_depenses
  strategy <- real_strategy
  # TODO filtrer avec subset pour accélérer try_strategy et réduire les bornes
  revenus <- real_revenus[subset, , drop = FALSE]
  depenses <- real_depenses[subset, , drop = FALSE]
  strategy <- real_strategy[subset, , drop = FALSE]
  ages <- pmin(ages, start_age + max(subset) - 1)
  depenses$depenses <- depenses$depenses * 0 # si je ne dépense rien, je pourrais cotiser plus (bornes max)
  strategy <- strategy * 0 # reset la stratégie pour ne rien cotiser
  actifs_hist <- try_strategy(actifs, revenus, depenses, strategy, passed_revenus, start_age, start_age + max(subset) - 1)
  
  # group by bloc splits
  groups <- matrix(
    c(
      head(ages - min(ages) + 1, -1),
      # TODO ajuster les bornes? ne fonctionne pas si start_age = 25, max_age = 25
      tail(ages - min(ages) + 1, -1) - 1
    ),
    ncol = 2
  )
  
  fake_i <- rendement + dividend_yield
  actuariat_factor <- (fake_i^groups[, 2] - 1) / (fake_i - 1)
  
  tmp <- apply(groups, 1, function(idx) max(actifs_hist[idx[1]:idx[2], "cash"]) / (diff(idx) + 1))
  maxes <- matrix(
    c(
      # ça suppose que si je sors de l'argent, je pourrais ne pas pouvoir le réinvestir à cause de ces bornes
      tmp, # NONENR
      rep(actifs$celi$contrib_lim + actifs$celi$contrib_yearly, length(tmp)), # CELI
      rep(actifs$reer$plafond, length(tmp)), # REER
      ((actifs$reer$droits_cotis_inutilises + actifs$reer$cotis_versees_non_deduites) * fake_i^groups[, 2] +
         actifs$reer$plafond * actuariat_factor) / (1 + apply(groups, 1, diff)) # déduction REER
    ),
    nrow = 4,
    byrow = TRUE
  )
  
  mins <- matrix(
    c(
      -((actifs$nonenr_capital + actifs$nonenr_gain) * fake_i^groups[, 2] +
          tmp * actuariat_factor) / (1 + apply(groups, 1, diff)),
      -(actifs$celi$current_value * fake_i^groups[, 2] +
          actifs$celi$contrib_yearly * actuariat_factor) / (1 + apply(groups, 1, diff)),
      -((
        actifs$reer$current_value +
          actifs$reer$droits_cotis_inutilises +
          actifs$reer$cotis_versees_non_deduites
      ) * fake_i^groups[, 2] + actifs$reer$plafond * actuariat_factor) / (1 + apply(groups, 1, diff)),
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

