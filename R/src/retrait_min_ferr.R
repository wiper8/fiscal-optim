# retrait minimum du FERR en raison de l'âge. Exprimé en % de l'actif dans le FERR
retrait_min_ferr <- function(age) {
  pct <- c(0, 0.0528, 0.054, 0.0553, 0.0567, 0.0582, 0.0598, 0.0617, 0.0636, 0.0658, 0.0682, 0.0708, 0.0738, 0.0771,
          0.0808, 0.0851, 0.0899, 0.0955, 0.1021, 0.1099, 0.1192, 0.1306, 0.1449, 0.1634, 0.1879, 0.2)
  
  age <- pmin(age, 95)
  age <- pmax(age, 70)
  pct[age - (70 - 1)]
}
