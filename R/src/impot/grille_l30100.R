grille_l30100 <- function(age, l23600) {
  if (age < 65) return(0)
  max(0, 9028 - 0.15 * max(0, l23600 - 45522))
}
