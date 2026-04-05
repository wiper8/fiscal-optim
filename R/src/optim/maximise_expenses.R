source("R/src/optim/given_strat_optim_flat_expen.R")

# maximiser une quantitée d'argent flat dans le temps en optimisant une stratégie de cotisations/retraits fiscaux
maximise_expenses <- function(start_age, max_age, ...) {
  to_optim <- function(flat_strategy) {
    print(round(flat_strategy, 2))
    strategy <- get_strat(flat_strategy, start_age, max_age)
    expenses <- given_strat_optim_flat_expen(real_strategy = strategy, ...)
    print(paste0("objective : ", round(expenses, 2)))
    -expenses
  }

  # nolint start: commented_code_linter
  # ui %*% theta - ci > 0
  ui_constr_mat <- matrix(c(
      1, 0, 0, 0, 0, # COTIS_NONENR >= 0
      0, 1, 0, 0, 0,  # SELL_NONENR >= 0
      0, 0, 0, 0, 1 # DEDUCE_REER >= 0
    ),
    ncol = 5,
    byrow = TRUE,
    dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
  )
  ci_constr <- c(0, 0, 0) - 0.01 # une cenne pour epsilon à cause du >= vs >
  theta <- rep(0, 5)
  # nolint end

  optim_res <- constrOptim(
    theta = theta,
    f = to_optim,
    grad = NULL,
    ui = ui_constr_mat,
    ci = ci_constr,
    control = list(
      parscale = rep(10000, length(theta)),
      ndeps = 10 # eps pour estimation du gradient
    )
  )

  # TODO récursivement (ou pas) re-séparer l'espace de recherche de 1x5 à 2x5 paramètres theta,
  # pour affiner la recherche. Présentement on suppose que la strategy doit être la même toute la vie durant, ce qui
  # est évidemment faux.

  list(depenses = -optim_res$value, get_strat(optim_res$par, start_age, max_age))
}

get_strat <- function(flat_strategy, start_age, max_age) {
  matrix(
    flat_strategy,
    nrow = max_age - start_age + 1,
    ncol = 5,
    byrow = TRUE,
    dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
  )
}
