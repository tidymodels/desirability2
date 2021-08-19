check_numeric <- function(x) {
  if (!is.vector(x) || !is.numeric(x)) {
    rlang::abort("`x` should be a numeric vector.")
  }
  invisible(NULL)
}

check_categorical <- function(x) {
  if (!is.character(x) & !is.factor(x)) {
    rlang::abort("`x` should be a character or factor vector.")
  }
  invisible(NULL)
}

check_unit_range <- function(x) {
  msg <- "Desirability values should be numeric in the range [0, 1]."
  if (!is.vector(x) || !is.numeric(x)) {
    rlang::abort(msg)
  }
  x <- x[!is.na(x)]
  if (length(x) > 0 && any(x < 0 | x > 1)) {
    rlang::abort(msg)
  }
  invisible(NULL)
}
