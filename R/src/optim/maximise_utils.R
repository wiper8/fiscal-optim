get_strat <- function(flat_strategy, start_age, max_age, bloc_splits = NULL) {
  dimnm <- list(NULL, c("NET_COTIS_NONENR", "NET_COTIS_CELI", "NET_COTIS_REER", "DEDUCE_REER"))
  n_col <- length(dimnm[[2]])

  stopifnot(all(bloc_splits <= max_age & start_age <= bloc_splits))
  ages <- unique(c(start_age, sort(bloc_splits), max_age))

  if (length(ages) == 1) {
    return(matrix(
      flat_strategy,
      nrow = 1,
      ncol = n_col,
      byrow = TRUE,
      dimnames = dimnm
    ))
  }

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

subset_strat <- function(theta, idx, ages) {
  n_col <- 4
  ages <- ages - ages[1] + 1
  blocs_keep <- mapply(function(x, y) any(x:y %in% idx), head(ages, -1), tail(ages, -1) - 1)
  as.vector(t(matrix(theta, ncol = n_col, byrow = TRUE)[blocs_keep, , drop = FALSE]))
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

stop_limit_time <- function(timer_start, limit_time, verbose) {
  time_passed <- as.numeric(difftime(Sys.time(), timer_start, units = "mins"))
  if (verbose >= 5) message(paste0(" Time : ", floor(time_passed), " / ", ceiling(limit_time)))
  if (time_passed > limit_time) stop("Temps limite atteint")
}
