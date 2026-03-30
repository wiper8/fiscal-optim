source("R/src/impot/qc/annexe_u.R")

# TODO pas certain de l'esprit de l'annexe u pour la déduction... ma conclusion est que c'est le total des cotisations 
# supplémentaires, mais je ne vois pas le lien
expect_equal(
  annexe_u(c(0, 3000, 10000, 50000, 71000, 72000, 78000, 85000, 100000, 150000, 500000)),
  c(0, 0, 65, 465, 675, 706, 946, 1074, 1074, 1074, 1074)
)

TRUE
