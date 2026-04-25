source("R/src/optim/given_strat_optim_expen.R")
source("R/src/optim/initial_solution.R")
source("R/src/optim/particle_swarm.R")
source("R/src/optim/get_bounds.R")

# maximiser une quantitée d'argent flat dans le temps en optimisant une stratégie de cotisations/retraits fiscaux
maximise_expenses <- function(start_age, max_age, bloc_splits = NULL, previous_solution = NULL, ..., limit_time = 10,
                              verbose_max = TRUE, optimiser = c("swarm", "constrOptim")) {
  timer_start <- Sys.time()
  counter <- 1
  optimiser <- match.arg(optimiser)

  to_optim <- function(flat_strategy) {
    time_passed <- as.numeric(difftime(Sys.time(), timer_start, units = "mins"))
    if (time_passed > limit_time) stop("Temps limite atteint")
    if (verbose_max) print(paste0(
      "Counter : ", counter,
      " Time : ", round(time_passed), " / ", limit_time
    ))
    counter <<- counter + 1
    if (verbose_max) print(to_k(flat_strategy))
    strategy <- get_strat(flat_strategy, start_age, max_age, bloc_splits)
    expenses <- given_strat_optim_expen(real_strategy = strategy, ..., previous_min_bound = previous_min_bound)
    if (is.null(previous_min_bound)) {
      previous_min_bound <<- expenses
      best_strat <<- flat_strategy
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

  stopifnot(all(bloc_splits <= max_age & start_age <= bloc_splits))
  ages <- unique(c(start_age, sort(bloc_splits), max_age))

  theta <- previous_solution %||% initial_solution(ages, actifs)
  previous_min_bound <- NULL
  previous_min_bound <- -to_optim(theta)

  tryCatch({
    if (optimiser == "swarm") {
      tmp_bounds <- get_bounds(ages = ages, ...)
      particle_swarm(
        theta = theta,
        f = to_optim,
        swarm_iter = 100000000, # car la limite de temps s'appliquera
        lower_bounds = tmp_bounds$lower,
        upper_bounds = tmp_bounds$upper
      )
    } else if (optimiser == "constrOptim") {
      # nolint start: commented_code_linter
      base_ui <- matrix(
        c(
          0, 0, 0, 1 # DEDUCE_REER >= 0
        ),
        ncol = 4,
        byrow = TRUE
      )

      # ui %*% theta - ci > 0
      ui_constr_mat <- kronecker(diag(length(ages)), base_ui)

      # une cenne pour epsilon à cause du >= vs > dans ui %*% theta - ci > 0
      ci_constr <- rep(0, nrow(ui_constr_mat)) - 0.01
      # nolint end

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
    }
  }, error = function(e) {
    message("Stopped early: ", e$message)
  })

  # calculer avec précision les dépenses disponibles (objectif de l'optimisation)
  args <- list(...)
  args$real_strategy <- get_strat(best_strat, start_age, max_age, bloc_splits)
  args$eps <- 0.01
  args$previous_min_bound <- NULL # pour une optimisation complète from scratch
  expenses <- do.call(given_strat_optim_expen, args)

  list(depenses = expenses, strategy = args$real_strategy, theta = best_strat)
}

get_strat <- function(flat_strategy, start_age, max_age, bloc_splits = NULL) {
  dimnm <- list(NULL, c("NET_COTIS_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
  n_col <- length(dimnm[[2]])

  stopifnot(all(bloc_splits <= max_age & start_age <= bloc_splits))
  ages <- unique(c(start_age, sort(bloc_splits), max_age))
  res <- matrix(
    flat_strategy[1:n_col + n_col * (1 - 1)],
    nrow = ages[1 + 1] - ages[1] + 1 * (max_age == ages[2]),
    ncol = n_col,
    byrow = TRUE,
    dimnames = dimnm
  )

  for (i in seq_len(length(ages) - 2)) {
    res <- rbind(
      res,
      matrix(
        flat_strategy[1:n_col + n_col * i],
        nrow = ages[i + 2] - ages[i + 1] + 1 * (max_age == ages[i + 2]),
        ncol = n_col,
        byrow = TRUE,
        dimnames = dimnm
      )
    )
  }
  res
}

to_k <- function(x) {
  x_num <- as.numeric(x)

  sign <- ifelse(x_num < 0, "-", "")
  x_abs <- abs(x_num)

  k <- x_abs / 1000

  ifelse(
    x_abs < 1000,
    paste0(sign, "0k"),
    paste0(sign, round(k), "k")
  )
}
