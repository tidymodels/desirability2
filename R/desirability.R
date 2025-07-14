# ------------------------------------------------------------------------------
# Basic data on desirability functions

# fmt: skip
all_f <- rlang::syms(c("minimize", "maximize", "constrain", "target", "category"))
# fmt: skip
all_d <- rlang::syms(c("d_min", "d_max", "d_box", "d_target", "d_category"))

req_args <-
  list(
    d_min = c("low", "high"),
    d_max = c("low", "high"),
    d_box = c("low", "high"),
    d_target = c("low", "high", "target"),
    d_category = c("categories")
  )
names(req_args) <- all_d

# ------------------------------------------------------------------------------
# S7 scaffolding

new_desirability_set <- function(inputs, translated, variables) {
  desirability_set(inputs = inputs,
                   translated = translated,
                   variables = variables)
}

desirability_set <- S7::new_class(
  "desirability_set",
  properties = list(
    inputs = S7::class_list,
    translated = S7::class_list,
    variables = S7::class_list
  )
)

S7::method(print, desirability_set) <- function(x, ...) {
  cli::cli_div()
  cli::cli_h1("Simultaneous Optimization via Desirability Functions")

  cli::cli_text()

  vals <- sort(unique(unlist(x@variables)))
  cli::cli_text(
    "{length(x@inputs)} desirability function{?s} for {length(vals)} variable{?s}"
  )
  cli::cli_text("Variables: {.val {vals}}.")

  cli::cli_end()

    invisible(x)
  }

# ------------------------------------------------------------------------------

#' High-level interface to specifying desirability functions
#'
#' @param ... using a goal function (see below) and the variable to be
#' optimized. Other arguments should be specified as needed but **must be
#' named**. Order of the arguments does not matter.
#' @param .use_data A single logical to specify whether all translated
#' desirability functions (such as [d_max()]) should enable `use_data = TRUE` to
#' fill in any unspecified required arguments.
#' @return An object of class `"desirability_set"` that can be used to make
#' a set of desirability functions.
#' @keywords internal
#' @details
#' The following set of nonexistent functions are used to specify an
#' optimization goal:
#' - `maximize()` (corresponding to  [d_max()])
#' - `minimize()`  ([d_min()])
#' - `target()` ([d_target()])
#' - `constrain()` ([d_box()])
#' - `categories()` ([d_max()])
#'
#' For example, if you wanted to jointly maximize a regression model’s Rsquared
#' while minimizing the RMSE, you could use
#'
#' \preformatted{
#'   desirability(
#'     minimize(rmse, scale = 3),
#'     maximize(rsq)
#'  )
#' }
#'
#' Where the `scale` argument makes the desirability curve more stringent.
#' @export
desirability <- function(..., .use_data = FALSE) {
  raw_inputs <- rlang::enexprs(...)
  if (length(raw_inputs) == 0) {
    cli::cli_abort("At least one optimization goal (e.g., {.fn maximize}) should be declared.")
  }
  check_arg_names(raw_inputs)
  check_fn_args(raw_inputs, all_f)


  new_fns <- translate_fn_args(raw_inputs, vals = all_f, subs = all_d, .use_data)

  variables <- purrr::map(raw_inputs, ~ all.vars(.x[[2]]))

  new_desirability_set(
    inputs = raw_inputs,
    translated = new_fns,
    variables = variables
  )
}

# ------------------------------------------------------------------------------
# Validation functions

check_fn_args <- function(x, vals, call = rlang::env_parent()) {
  fns <- purrr::map_chr(x, ~ rlang::expr_deparse(.x[[1]])) # TODO don't need to deparse
  vals_chr <- purrr::map_chr(vals, ~ rlang::expr_deparse(.x))

  is_good <- fns %in% vals
  if (any(!is_good)) {
    cli::cli_abort(
      "The following functions are unknown to the  {.pkg desirability2} package:
		{.fn {fns[!is_good]}}. Please use one of: {.or {.fn {all_f}}}.",
      call = call
    )
  }
  invisible(TRUE)
}

get_nms <- function(x) {
  res <- names(x)
  if (is.null(res)) {
    res <- rep("", length(x))
  }
  # first name is for function
  res[-1]
}

check_arg_names <- function(x, call = rlang::env_parent()) {
  num_args <- lengths(x) - 1L

  if (any(num_args == 0)) {
    cli::cli_abort(
      "There needs to be at least one argument to the optimization goal
      functions.",
      call = call
    )
  }

  nms <- purrr::map(x, get_nms)
  num_nms <- purrr::map_int(nms, length)
  good_first_nm <- purrr::map_lgl(nms, ~ .x[1] == "")

  if (any(!good_first_nm)) {
    bad_first_nms <- which(!good_first_nm)
    num_bad_first_nms <- length(bad_first_nms)
    cli::cli_abort(
      "{num_bad_first_nms} optimization goal{?s} {?has/have} a first argument that
      is named. {?It/They} should be unnamed.",
      call = call
    )
  }
  good_other_names <- purrr::map_lgl(nms, ~ all(.x[-1] != ""))
  if (any(!good_other_names)) {
    bad_other_nms <- which(!good_other_names)
    num_bad_other_nms <- length(bad_other_nms)
    cli::cli_abort(
      "{num_bad_other_nms} optimization goal{?s} {?has/have} additional arguments that
      are {.strong not} named. All but the first argument should be named.",
      call = call
    )
  }

  invisible(TRUE)
}

# ------------------------------------------------------------------------------
# Helper functions

match_fn <- function(orig, vals) {
  which(purrr::map_lgl(vals, ~ identical(.x, orig)))
}

index_fn <- function(fns, vals) {
  purrr::map_int(fns, ~ match_fn(.x, vals = vals))
}

sub_fn <- function(x, ind, vals) {
  x[[1]] <- vals[[ind]]
  x
}

maybe_use_data <- function(x) {
  fn <- x[[1]]
  if (!identical(fn, rlang::sym("d_category"))) {
    x <- rlang::call_modify(x, use_data = TRUE)
  }
  x
}

translate_fn_args <- function(x, vals, subs, .use_data) {
  fns <- purrr::map(x, ~ .x[[1]])
  ind <- index_fn(fns, vals = vals)

  y <- purrr::map2(x, ind, ~ sub_fn(.x, .y, vals = subs))

  if (.use_data) {
    # In case the user did not specify all of the required arguments, tell the
    # functions to use the data to impute them. If they did set values for all
    # of the required arguments, `use_data = TRUE` has no effect.
    y <- purrr::map(y, maybe_use_data)
  }
  y
}

# ------------------------------------------------------------------------------
# Tools to help determine if we need to splice in known args (like low or high)
# or to add `use_data = TRUE` to fil in the blanks with the data.

get_missing_args <- function(x) {
  fns <- purrr::map(x, 1)
  inds <- index_fn(fns, vals = all_d)
  args_req <- purrr::map(inds, ~ req_args[[.x]])
  args_given <- purrr::map(x, ~ get_named_args(.x))
  missing_args <- purrr::map2(args_given, args_req, ~ setdiff(.y, .x))
  missing_args
}

get_named_args <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    return(character(0))
  }
  nms[nms != ""]
}

