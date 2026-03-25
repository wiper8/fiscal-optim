# impôt provincial
table_impot_qc <- matrix(
  c(
    0.14, 0.19, 0.24, 0.2575,
    0, 53255, 106495, 129590
  ),
  nrow = 2, byrow = TRUE
)

grille_401 <- function(l299) {
  table_impot_qc[1, 1] * pmin(l299, table_impot_qc[2, 2]) +
    table_impot_qc[1, 2] * pmax(0, pmin(l299, table_impot_qc[2, 3]) - table_impot_qc[2, 2]) +
    table_impot_qc[1, 3] * pmax(0, pmin(l299, table_impot_qc[2, 4]) - table_impot_qc[2, 3]) +
    table_impot_qc[1, 4] * pmax(0, l299 - table_impot_qc[2, 4])
}
