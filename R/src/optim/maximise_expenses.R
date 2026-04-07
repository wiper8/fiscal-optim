source("R/src/optim/given_strat_optim_flat_expen.R")

# maximiser une quantitée d'argent flat dans le temps en optimisant une stratégie de cotisations/retraits fiscaux
maximise_expenses <- function(start_age, max_age, bloc_splits = NULL, previous_solution = NULL, ..., limit_itr = 100,
                              verbose_max = TRUE) {
  counter <- 1

  to_optim <- function(flat_strategy) {
    if (counter > limit_itr) stop("Nombre d'itérations atteint")
    if (verbose_max) print(paste0("Counter : ", counter, " / ", limit_itr))
    counter <<- counter + 1
    if (verbose_max) print(round(flat_strategy, 2))
    strategy <- get_strat(flat_strategy, start_age, max_age, bloc_splits)
    expenses <- given_strat_optim_flat_expen(real_strategy = strategy, ..., previous_min_bound = previous_min_bound)
    if (is.null(previous_min_bound)) {
      previous_min_bound <<- expenses
    } else {
      if (expenses > previous_min_bound) {
        previous_min_bound <<- expenses
        best_strat <<- flat_strategy
      }
    }
    if (verbose_max) print(paste0("objective : ", round(expenses, 2)))
    if (verbose_max) print(paste0("Lower bound : ", round(previous_min_bound, 2)))
    -expenses
  }

  # nolint start: commented_code_linter
  base_ui <- matrix(
    c(
      1, 0, 0, 0, 0, # COTIS_NONENR >= 0
      0, 1, 0, 0, 0, # SELL_NONENR >= 0
      0, 0, 0, 0, 1 # DEDUCE_REER >= 0
    ),
    ncol = 5,
    byrow = TRUE
  )

  # ui %*% theta - ci > 0
  ui_constr_mat <- kronecker(diag(length(bloc_splits) + 1), base_ui)
  ci_constr <- rep(0, nrow(ui_constr_mat)) - 0.01 # une cenne pour epsilon à cause du >= vs > dans ui %*% theta - ci > 0
  theta <- previous_solution %||% rep(0, ncol(ui_constr_mat))
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
        reltol = 0.0001, # 10$ / ~50000$
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
  args$real_strategy <- get_strat(best_strat, start_age, max_age, bloc_splits)
  args$eps <- 0.01
  args$previous_min_bound <- NULL # pour une optimisation complète from scratch
  args$verbose <- TRUE
  expenses <- do.call(given_strat_optim_flat_expen, args)

  list(depenses = expenses, strategy = args$real_strategy, theta = best_strat)
}

get_strat <- function(flat_strategy, start_age, max_age, bloc_splits = NULL) {
  dimnm <- list(NULL, c("COTIS_NONENR", "SELL_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))

  stopifnot(all(bloc_splits <= max_age & start_age <= bloc_splits))
  ages <- unique(c(start_age, sort(bloc_splits), max_age))
  res <- matrix(
    flat_strategy[1:5 + 5 * (1 - 1)],
    nrow = ages[1 + 1] - ages[1] + 1 * (max_age == ages[2]),
    ncol = 5,
    byrow = TRUE,
    dimnames = dimnm
  )

  for (i in seq_len(length(ages) - 2)) {
    res <- rbind(
      res,
      matrix(
        flat_strategy[1:5 + 5 * i],
        nrow = ages[i + 2] - ages[i + 1] + 1 * (max_age == ages[i + 2]),
        ncol = 5,
        byrow = TRUE,
        dimnames = dimnm
      )
    )
  }
  res
}
