annexe_3 <- function(gains_T3) {
  # partie 4
  l17600 <- gains_T3
  l19700 <- l17600

  # partie 5
  l19900 <- l19700 * 0.5
  # on reporte indéfiniment les pertes sans jamais les appliquer pour simplifier 
  pmax(l19900, 0)
}
