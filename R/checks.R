check_numeric <- function(x, input = "`x`", call) {
  if (!is.vector(x) || !is.numeric(x)) {
    cli::cli_abort("{.arg {input}} should be {an} numeric vector.")
  }
  invisible(NULL)
}

check_categorical <- function(x, call) {
  if (!is.character(x) & !is.factor(x)) {
    cli::cli_abort("{.arg x} should be a character or factor vector.")
  }
  invisible(NULL)
}

check_unit_range <- function(x, call) {
  msg <- c(
    "Desirability values should be numeric and complete in the range [0, 1].",
    "i" = "Current values are {.obj_type_friendly {x}}.",
    "i" = "{?Some v/V}alue{?s} {?are/is} outside the [0, 1] range."
  )

  if (!is.vector(x) || !is.numeric(x)) {
    cli::cli_abort(msg, call = call)
  }
  x <- x[!is.na(x)]
  if (length(x) > 0 && any(x < 0 | x > 1)) {
    cli::cli_abort(msg, call = call)
  }

  invisible(NULL)
}

check_value_order <- function(low, high, target = NULL, call) {
  check_number_decimal(low, call = call)
  check_number_decimal(high, call = call)
  check_number_decimal(target, allow_null = TRUE, call = call)

  if (!is.null(target)) {
    ord <- low < target & target < high
    if (!ord) {
      cli::cli_abort("The values should be {.code low < target < high}  (actual
                     are {low}, {target}, and {high}).", call = call)
    }
  }

  ord <- low < high
  if (!ord) {
    cli::cli_abort("The values should be {.code low < high} (actual are {low}
                   and {high}).", call = call)
  }

  invisible(NULL)
}

is_vector_args <- function(values, d, call) {
  if (!is.vector(values) || !is.numeric(values)) {
    cli::cli_abort("{.arg values} should be a numeric vector.", call = call)
  }
  if (!is.vector(d) || !is.numeric(d)) {
    cli::cli_abort("'d' should be a numeric vector.", call = call)
  }
  if (length(values) != length(d)) {
    cli::cli_abort("'{.arg values}' and '{.arg d}' should be the same length.",
                   call = call)
  }
  invisible(TRUE)
}


check_args <- function(arg, x, use_data, fn, type = "low",
                       call) {
  if (rlang::is_missing(arg)) {
    if (use_data) {
      type <- rlang::arg_match0(type, c("low", "high", "target"), error_call = call)
      .fn <- switch(type, low = min, high = max, target = stats::median)
      arg <- .fn(x, na.rm = TRUE)
    } else {
      cli::cli_abort("In {.fn {fn}}, argument {.arg {type}} is required when
                     {.code new_data = FALSE}.", call = call)
    }
  }
  arg
}

check_scale <- function(x, arg, call) {
  check_number_decimal(x, min = 0, arg = arg, call = call)
  invisible(NULL)
}

is_d_input <- function(x, call) {
  tmp <- purrr::map(x, check_numeric, input = "desirability", call = call)
  tmp <- purrr::map(x, check_unit_range, call = call)
  size <- purrr::map_int(x, length)
  if (length(unique(size)) != 1) {
    cli::cli_abort("All desirability inputs should have the same length.", call = call)
  }
  invisible(TRUE)
}

