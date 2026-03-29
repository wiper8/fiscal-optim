source("R/src/impot/fed/annexe_7.R")

expect_equal(
  annexe_7(
    cotisations_inutilisees_versees_dispo_a_deduire = c(3, Inf, 100),
    cotisations_versees_reer = c(2, 2, 2),
    deduction_reer = c(1, 5, 5),
    max_deductible_reer = c(Inf, 8, 8)
  ),
  list(
    l20800 = c(1, 5, 5),
    l24500 = c(2, 2, 2),
    cotis_inutil_vers_disp_deduc = c(4, Inf, 97)
  )
)

expect_error(
  annexe_7(
    cotisations_inutilisees_versees_dispo_a_deduire = 3,
    cotisations_versees_reer = 2,
    deduction_reer = 5.1,
    max_deductible_reer = Inf
  )
)

expect_error(
  annexe_7(
    cotisations_inutilisees_versees_dispo_a_deduire = 100,
    cotisations_versees_reer = 2,
    deduction_reer = 8.1,
    max_deductible_reer = 8
  )
)

TRUE
