source("R/src/optim/given_strat_optim_flat_expen.R")

# maximiser une quantitée d'argent flat dans le temps en optimisant une stratégie de cotisations/retraits fiscaux
maximise_expenses <- function(start_age, max_age, ..., limit_itr = 100) {
  counter <- 0

  to_optim <- function(flat_strategy) {
    print(paste0("Counter : ", counter, " / ", limit_itr))
    if (counter == limit_itr) stop("Nombre d'itérations atteint")
    print(round(flat_strategy, 2))
    strategy <- get_strat(flat_strategy, start_age, max_age)
    expenses <- given_strat_optim_flat_expen(real_strategy = strategy, ..., previous_min_bound = previous_min_bound)
    print(paste0("objective : ", round(expenses, 2)))
    counter <<- counter + 1
    if (is.null(previous_min_bound)) {
      previous_min_bound <<- expenses
    } else {
      if (expenses > previous_min_bound) {
        previous_min_bound <<- expenses
        best_strat <<- flat_strategy
      }
    }
    print(paste0("Lower bound : ", round(previous_min_bound, 2)))
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
  ci_constr <- rep(0, nrow(ui_constr_mat)) - 0.01 # une cenne pour epsilon à cause du >= vs > dans ui %*% theta - ci > 0
  theta <- rep(0, ncol(ui_constr_mat))
  # nolint end

  previous_min_bound <- NULL
  previous_min_bound <- -to_optim(theta)

  tryCatch({
    constrOptim(
      theta = theta,
      f = to_optim,
      grad = NULL,
      ui = ui_constr_mat,
      ci = ci_constr,
      control = list(
        reltol = 0.0005, # 50$ / ~50000$
        parscale = rep(10000, length(theta)),
        ndeps = 10 # eps pour estimation du gradient
      )
    )
  }, error = function(e) {
    message("Stopped early: ", e$message)
  })

  # TODO récursivement (ou pas) re-séparer l'espace de recherche de 1x5 à 2x5 paramètres theta,
  # pour affiner la recherche. Présentement on suppose que la strategy doit être la même toute la vie durant, ce qui
  # est évidemment faux.¾

  # calculer avec précision les dépenses disponibles (objectif de l'optimisation)
  args <- list(...)
  args$real_strategy <- get_strat(best_strat, start_age, max_age)
  args$eps <- 0.01
  args$previous_min_bound <- 0
  args$verbose <- TRUE
  expenses <- do.call(given_strat_optim_flat_expen, args)

  # s'assurer que la stratégie fonctionne
  res_strat <- try_strategy(
    actifs, revenus, get_flat_expenses_ipc(start_age, max_age, previous_min_bound, inflation, ipc),
    strategy, passed_revenus
  )
  if (length(res_strat) == 1 && grepl("argent insuffisant", res_strat)) {
    browser()
    all.equal(
      get_flat_expenses_ipc(start_age, max_age, previous_min_bound, inflation, ipc),
      args
    )
    stop("Impossible de recréer le résultat de l'optimisation")
  }

  list(depenses = expenses, strategy = args$real_strategy)
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
