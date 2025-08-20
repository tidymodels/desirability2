check_numeric <- function(x, input = "x", call = rlang::caller_env()) {
  if (!is.vector(x) || !is.numeric(x)) {
    cli::cli_abort("{.arg {input}} should be a numeric vector.")
  }
  invisible(NULL)
}

check_categorical <- function(x, call = rlang::caller_env()) {
  if (!is.character(x) & !is.factor(x)) {
    cli::cli_abort(
      "{.arg x} should be a character or factor vector,
      not {.obj_type_friendly {x}}.",
      call = call
    )
  }
  invisible(NULL)
}

out_of_unit_range <- function(x) {
  x <- x[!is.na(x)]
  any(x < 0 | x > 1)
}

check_unit_range <- function(x, call = rlang::caller_env()) {
  msg <- c(
    "Desirability values should be numeric and complete in the range [0, 1]."
  )

  if (!is.vector(x) || !is.numeric(x)) {
    msg <- c(msg, "i" = "Current values are {.obj_type_friendly {x}}.")
    cli::cli_abort(msg, call = call)
  }

  if (out_of_unit_range(x) || length(x) > 1) {
    offenders <- sum(x < 0 | x > 1)
    msg <- c(
      msg,
      "i" = "{offenders} value{?s} {?is/are} outside the [0, 1] range."
    )

    cli::cli_abort(msg, call = call)
  }

  invisible(NULL)
}

check_value_order <- function(
  low,
  high,
  target = NULL,
  call = rlang::caller_env()
) {
  check_number_decimal(low, call = call)
  check_number_decimal(high, call = call)
  check_number_decimal(target, allow_null = TRUE, call = call)

  if (!is.null(target)) {
    ord <- low < target & target < high
    if (!ord) {
      cli::cli_abort(
        "The values should be {.code low < target < high}  (actual
                     are {low}, {target}, and {high}).",
        call = call
      )
    }
  }

  ord <- low < high
  if (!ord) {
    cli::cli_abort(
      "The values should be {.code low < high} (actual are {low}
                   and {high}).",
      call = call
    )
  }

  invisible(NULL)
}

check_vector_args <- function(values, d, call = rlang::caller_env()) {
  if (!is.vector(values) || !is.numeric(values)) {
    cli::cli_abort("{.arg values} should be a numeric vector.", call = call)
  }
  if (!is.vector(d) || !is.numeric(d)) {
    cli::cli_abort("'d' should be a numeric vector.", call = call)
  }
  if (length(values) != length(d)) {
    cli::cli_abort(
      "{.arg values} ({length(values)}) and {.arg d} ({length(d)}) should be the same length.",
      call = call
    )
  }
  invisible(TRUE)
}


check_args <- function(
  arg,
  x,
  use_data,
  fn,
  type = "low",
  call = rlang::caller_env()
) {
  if (rlang::is_missing(arg)) {
    if (use_data) {
      x <- x[!is.na(x)]
      if (is.numeric(x)) {
        x <- x[is.finite(x)]
      }
      if (length(x) == 0) {
        cli::cli_abort(
          "The data must have at least on finite and non-missing value.",
          call = call
        )
      }
      type <- rlang::arg_match0(
        type,
        c("low", "high", "target"),
        error_call = call
      )
      .fn <- switch(type, low = min, high = max, target = stats::median)
      arg <- .fn(x)
    } else {
      cli::cli_abort(
        "In {.fn {fn}}, argument {.arg {type}} is required when
                     {.code new_data = FALSE}.",
        call = call
      )
    }
  }
  arg
}

check_scale <- function(x, arg, call = rlang::caller_env()) {
  check_number_decimal(x, min = 0, arg = arg, call = call)
  invisible(NULL)
}

is_d_input <- function(x, call = rlang::caller_env()) {
  tmp <- purrr::map(x, check_numeric, input = "desirability", call = call)
  outside <- purrr::map_lgl(x, out_of_unit_range)
  if (any(outside)) {
    bad_cols <- names(x)[outside]
    cli::cli_abort(
      "{length(bad_cols)} {?of the} column{?s} {?is/are} not
                    within {.code [0, 1]}: {.val {bad_cols}}",
      call = call
    )
  }
  size <- purrr::map_int(x, length)
  if (length(unique(size)) != 1) {
    cli::cli_abort(
      "All desirability inputs should have the same length.",
      call = call
    )
  }
  invisible(TRUE)
}
