.comp_max <- function(x, low, high, scale, missing) {
  # TODO check for numeric
  # TODO check range for missing
  out <- x * NA
  out[x < low] <- 0
  out[x > high] <- 1
  out[x <= high & x >= low] <- ((x[x <= high & x >= low] - low)/ (high - low))^scale
  out[is.na(out)] <- missing
  out
}

