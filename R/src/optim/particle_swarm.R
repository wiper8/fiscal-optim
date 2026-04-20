particle_swarm <- function(theta, f, lower_bounds, upper_bounds,
                           n_particles = 50,
                           swarm_iter = 10,
                           w = 0.7,
                           c1 = 1.2,
                           c2 = 1.8,
                           ...) {
  d <- length(theta)
  stopifnot(length(lower_bounds) == d && length(upper_bounds) == d)

  # Initialize positions (particles x dimensions)
  feasable_solution <- rep(FALSE, n_particles * d)
  positions_init <- matrix(runif(n_particles * d), n_particles, d)
  positions <- positions_init
  repeat {
    positions_init <- matrix(runif(n_particles * d), n_particles, d)
    positions[!feasable_solution] <- positions_init[!feasable_solution]

    positions <- sweep(positions, 2, c(upper_bounds - lower_bounds), `*`)
    positions <- sweep(positions, 2, c(lower_bounds), `+`)
    # custom : move the matrix a little closer to initial theta
    alpha <- 0.4
    positions <- (1 - alpha) * positions + alpha * matrix(theta, nrow(positions), ncol = d, byrow = TRUE)
  
    # Evaluate fitness
    fitness <- apply(positions, 1, f, ...)
    feasable_solution[fitness < 0] <- TRUE

    # make sure initial positions give non-zeros results to start
    if (all(feasable_solution)) break
  }

  # Initialize velocity
  velocity <- matrix(
    runif(n_particles * d, -abs(upper_bounds - lower_bounds), abs(upper_bounds - lower_bounds)),
    n_particles,
    d
  )

  # Personal best
  pbest_positions <- positions
  pbest_values <- fitness

  # Global best
  gbest_index <- which.min(fitness)
  gbest_position <- positions[gbest_index, ]
  gbest_value <- fitness[gbest_index]

  for (iter in seq_len(swarm_iter)) {

    # Random matrices
    r_p <- matrix(runif(n_particles * d), n_particles, d)
    r_g <- matrix(runif(n_particles * d), n_particles, d)

    # Expand gbest to matrix
    gbest_matrix <- matrix(gbest_position, n_particles, d, byrow = TRUE)

    # Velocity update
    velocity <- w * velocity +
      c1 * r_p * (pbest_positions - positions) +
      c2 * r_g * (gbest_matrix - positions)

    # Position update
    positions <- positions + velocity

    # Clamp bounds
    positions <- pmax(positions, matrix(lower_bounds, n_particles, d, byrow = TRUE))
    positions <- pmin(positions, matrix(upper_bounds, n_particles, d, byrow = TRUE))

    # Evaluate fitness
    fitness <- apply(positions, 1, f, ...)

    # Update personal best
    improved <- fitness < pbest_values
    pbest_positions[improved, ] <- positions[improved, , drop = FALSE]
    pbest_values[improved] <- fitness[improved]

    # Update global best
    best_iter_index <- which.min(fitness)
    if (fitness[best_iter_index] < gbest_value) {
      gbest_value <- fitness[best_iter_index]
      gbest_position <- positions[best_iter_index, ]
    }

    cat("Iter:", iter, "Best:", gbest_value, "\n")
  }

  list(par = gbest_position, value = gbest_value)
}
