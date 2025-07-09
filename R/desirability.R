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

# ------------------------------------------------------------------------------

#' High-level interface to specifying desirability functions
#'
#' @param Arguments using a goal function (see below) and the variable to be
#' optimized. Other arguments should be specified as needed but **must be
#' named**. Order of the arguments does not matter.
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
desirability <- function(...) {
  raw_inputs <- rlang::enexprs(...)
  check_fn_args(raw_inputs, all_f)

  # check for un-named arguments

  new_fns <- translate_fn_args(raw_inputs, vals = all_f, subs = all_d)

  variables <- purrr::map(raw_inputs, ~ all.vars(.x[[2]]))

  new_desirability_set(
    inputs = raw_inputs,
    translated = new_fns,
    variables = variables
  )
}

# ------------------------------------------------------------------------------
# Helper functions

check_fn_args <- function(x, vals) {
  fns <- purrr::map_chr(x, ~ rlang::expr_deparse(.x[[1]])) # TODO don't need to deparse
  vals_chr <- purrr::map_chr(vals, ~ rlang::expr_deparse(.x))

  is_good <- fns %in% vals
  if (any(!is_good)) {
    cli::cli_abort(
      "The following functions are unknown to the  {.pkg desirability2} package:
		{.fn {fns[!is_good]}}. Please use one of: {.or {.fn {all_f}}}."
    )
  }
  invisible(TRUE)
}

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

translate_fn_args <- function(x, vals, subs) {
  fns <- purrr::map(x, ~ .x[[1]])
  ind <- index_fn(fns, vals = vals)
  y <- purrr::map2(x, ind, ~ sub_fn(.x, .y, vals = subs))
  # In case the user did not specify all of the required arguments, tell the
  # functions to use the data to impute them. If they did set values for all
  # of the required arguments, `use_data = TRUE` has no effect.
  y <- purrr::map(y, ~ rlang::call_modify(.x, use_data = TRUE))
}

print_method <- function(x, ...) {
  cli::cli_inform("Simultaneous Optimization via Desirability Functions")
  cat("\n")
  vals <- sort(unique(unlist(x$variables)))
  cli::cli_inform(
    "{length(x$inputs)} desirability function{?s} for {length(vals)} variable{?s}"
  )
  cli::cli_inform("Variables: {.val {vals}}.")

  invisible(x)
}

# ------------------------------------------------------------------------------
# Tools to help determine if we need to splice in known args (like low or high)
# or to add `use_data = TRUE` to fil in the blanks with the data.

get_missing_args <- function(x) {
  fns <- purrr::map(x, ~ .x[[1]])
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

