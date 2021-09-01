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

check_value_order <- function(low, high, target = NULL) {
  if (length(low) != 1 | !is.numeric(low) | is.na(low)) {
    rlang::abort("'low' should be a single numeric value.")
  }

  if (length(high) != 1 | !is.numeric(high) | is.na(high)) {
    rlang::abort("'high' should be a single numeric value.")
  }

  if (!is.null(target)) {
    if (length(target) != 1 | !is.numeric(target) | is.na(target)) {
      rlang::abort("'target' should be a single numeric value.")
    }
    ord <- low < target & target < high
    if (!ord) {
      rlang::abort("The values should be `low < target < high`.")
    }
  } else {
    ord <- low < high
    if (!ord) {
      rlang::abort("The values should be `low < high`.")
    }
  }
  invisible(TRUE)
}
