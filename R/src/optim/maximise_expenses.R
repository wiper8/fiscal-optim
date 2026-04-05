# maximiser une quantitée d'argent flat dans le temps en optimisant une stratégie de cotisations/retraits fiscaux
maximise_expenses <- function(actifs, revenus, passed_revenus) {
  to_optim <- function(depenses_and_flat_strategy) {
    strategy <- matrix(
      depenses_and_flat_strategy[-1],
      nrow = max_age - start_age + 1,
      ncol = 5,
      byrow = TRUE,
      dimnames = list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
    )
    try_strategy(actifs, revenus, depenses_and_flat_strategy[1], strategy, passed_revenus)
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
  # nolint end

  constrOptim(
    theta = c(0, 0, 0, 0, 0),
    f = to_optim,
    grad = NULL,
    ui = ui_constr_mat,
    ci = ci_constr,
    mu = 0
  )
}
