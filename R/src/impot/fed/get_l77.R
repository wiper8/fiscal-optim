# impôt
table_impot <- matrix(
  c(
    0.145, 0.205, 0.26, 0.29, 0.33,
    0, 57375, 114750, 177882, 253414
  ),
  nrow = 2, byrow = TRUE
)

get_l77 <- function(l26000) {
  stopifnot(all(l26000 >= 0))
  table_impot[1, 1] * pmin(l26000, table_impot[2, 2]) +
    table_impot[1, 2] * pmax(0, pmin(l26000, table_impot[2, 3]) - table_impot[2, 2]) +
    table_impot[1, 3] * pmax(0, pmin(l26000, table_impot[2, 4]) - table_impot[2, 3]) +
    table_impot[1, 4] * pmax(0, pmin(l26000, table_impot[2, 5]) - table_impot[2, 4]) +
    table_impot[1, 5] * pmax(0, l26000 - table_impot[2, 5])
}
