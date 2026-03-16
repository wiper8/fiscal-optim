TABLE_IMPOT <- matrix(
  c(
    0.145, 0.205, 0.26, 0.29, 0.33,
    0, 57375, 114750, 177882, 253414
  ),
  nrow = 2, byrow = TRUE
)

grille_l30000 <- function(l23600) {
  # conditions
  l1 <- 14538
  l2 <- 1591
  if (l23600 <= TABLE_IMPOT[2, 4]) return(l1 + l2)
  if (l23600 >= TABLE_IMPOT[2, 5]) return(l1)
  
  l1 + l2 * pmin(
    1,
    pmax(0, TABLE_IMPOT[2, 5] - l23600) / (TABLE_IMPOT[2, 5] - TABLE_IMPOT[2, 4])
  )
}
