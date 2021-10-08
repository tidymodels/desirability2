check_numeric <- function(x, input = "`x`") {
  if (!is.vector(x) || !is.numeric(x)) {
    rlang::abort(paste0(input, " should be a numeric vector."))
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
  msg <- "Desirability values should be numeric and complete in the range [0, 1]."
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
  if (length(low) != 1 || !is.numeric(low) || is.na(low)) {
    rlang::abort("'low' should be a single numeric value.")
  }

  if (length(high) != 1 || !is.numeric(high) || is.na(high)) {
    rlang::abort("'high' should be a single numeric value.")
  }

  if (!is.null(target)) {
    if (length(target) != 1 || !is.numeric(target) || is.na(target)) {
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

check_vectors <- function(values, d) {
  if (!is.vector(values) || !is.numeric(values)) {
    rlang::abort("'values' should be a numeric vector.")
  }
  if (!is.vector(d) || !is.numeric(d)) {
    rlang::abort("'d' should be a numeric vector.")
  }
  if (length(values) != length(d)) {
    rlang::abort("'values' and 'd' should be the same length.")
  }
  invisible(TRUE)
}


check_args <- function(arg, x, use_data, fn, type = "low") {
  if (rlang::is_missing(arg)) {
    if (use_data) {
      type <- rlang::arg_match0(type, c("low", "high", "target"))
      .fn <- switch(type, low = min, high = max, target = stats::median)
      arg <- .fn(x, na.rm = TRUE)
    } else {
      rlang::abort(
        glue::glue("In `{fn}()`, argument '{type}' is required when 'new_data = FALSE'.")
      )
    }
  }
  arg
}

