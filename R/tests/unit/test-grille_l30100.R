source("R/src/impot/fed/grille_l30100.R")

expect_equal(
  apply(
    expand.grid(
      c(60, 64, 65, 100),
      c(0, 40000, 60000, 104000, 110000)
    ),
    1,
    function(x) grille_l30100(x[1], x[2])
  ),
  c(0, 0, 9028, 9028, 0, 0, 9028, 9028, 0, 0, 6856.3, 6856.3, 0, 0, 256.3, 256.3, 0, 0, 0, 0)
)

TRUE
