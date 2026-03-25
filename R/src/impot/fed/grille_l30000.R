table_impot <- matrix(
  c(
    0.145, 0.205, 0.26, 0.29, 0.33,
    0, 57375, 114750, 177882, 253414
  ),
  nrow = 2, byrow = TRUE
)

# montant personnel de base (souvent considéré comme le premier bracket d'impôt)
grille_l30000 <- function(l23600) {
  # conditions
  cond1 <- l23600 <= table_impot[2, 4]
  cond2 <- l23600 >= table_impot[2, 5]

  l1 <- 14538
  l2 <- 1591

  res <- l1 + l2 * pmin(
    1,
    pmax(0, table_impot[2, 5] - l23600) / (table_impot[2, 5] - table_impot[2, 4])
  )

  cond1 * (l1 + l2) +
    cond2 * l1 +
    (!cond1 & !cond2) * res
}
