.comp_max <- function(x, low, high, scale, missing) {
  # TODO check for numeric
  # TODO check range for missing
  out <- rep(missing, length(x))
  out[x < low & !is.na(x)] <- 0
  out[x > high & !is.na(x)] <- 1
  middle <- x <= high & x >= low & !is.na(x)
  out[middle] <- ((x[middle] - low)/ (high - low))^scale
  out
}

.comp_min <- function(x, low, high, scale, missing) {
  # TODO check for numeric
  # TODO check range for missing
  out <- rep(missing, length(x))
  out[x < low & !is.na(x)] <- 1
  out[x > high & !is.na(x)] <- 0
  middle <- x <= high & x >= low & !is.na(x)
  out[middle] <- ((x[middle] - high)/ (low - high))^scale
  out
}


.comp_target <- function(x, low, target, high, scale_low, scale_high, missing) {
  out <- rep(missing, length(x))

  out[(x < low | x > high) &  !is.na(x)] <- 0
  lower <- x <= target & x >= low & !is.na(x)
  out[lower] <- ((x[lower] - low) / (target - low))^scale_low
  upper <- x <= high & x >= target & !is.na(x)
  out[upper] <- ((x[upper] - high) / (target - high))^scale_high

  out
}


.comp_custom <- function(x, values, d, missing) {
  ord <- order(values)
  values <- values[ord]
  d <- d[ord]

  out <- rep(missing, length(x))
  out[x < min(values) & !is.na(x)] <- 0
  out[x > max(values) & !is.na(x)] <- 1

  middle <- x < max(values) & x > min(values) & !is.na(x)
  x_mid <- x[middle]
  out[middle] <- stats::approx(values, d, xout = x_mid)$y

  out
}


.comp_box <- function(x, low, high, missing) {
  out <- rep(missing, length(x))
  out[x < low | x > high & !is.na(x)] <- 0
  out[x >= low & x <= high & !is.na(x)] <- 1

  out
}


.comp_category <- function(x, values, missing) {

  # check value names and values, make consisten factors when needed

  values <- tibble::tibble(value = names(values), d = unname(values))
  dat <- tibble::tibble(value = x, order = seq_along(x))
  out <- dplyr::left_join(dat, values, by = "value")

  out$d[out$order]
}
