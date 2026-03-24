# gain en capital
annexe_3 <- function(gains_t3) {
  # partie 4
  l17600 <- gains_t3
  l19700 <- l17600 # total gain ou perte en capital

  # partie 5
  l19900 <- l19700 * 0.5 # total gain ou perte en capital IMPOSABLE

  # TODO on reporte indéfiniment les pertes sans jamais les appliquer pour simplifier 
  pmax(l19900, 0)
}
