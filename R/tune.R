#' Investigate best tuning parameters
#'
#' Analogs to [tune::show_best()] and [tune::select_best()] that can
#' simultaneously optimize multiple metrics or characteristics using
#' desirability functions.
#'
#' @inheritParams tune::show_best
#' @param ... One or more desirability selectors to configure the optimization.
#' @return [show_best_desirability()] returns a tibble with `n` rows while
#' [select_best_desirability()] returns a single row. When showing the results,
#' the metrics are presented in "wide format" (one column per metric) and there
#' are new columns for the corresponding desirability values (each starts with
#' `.d_`).
#'
#' @details Desirability functions might help when selecting the best model
#' based on more than one performance metric. The user creates a desirability
#' function to map values of a metric to a `[0, 1]` range where 1.0 is most
#' desirable and zero is unacceptable. After constructing these for the metric
#' of interest, the overall desirability is computed using the geometric mean
#' of the individual desirabilities.
#'
#' The verbs that can be used in `...` (and their arguments) are:
#'
#' - `maximize()` when larger values are better, such as the area under the ROC
#'    score.
#' - `minimize()` for metrics such as RMSE or the Brier score.
#' - `target()` for cases when a specific value of the metric is important.
#' - `constrain()` is used when there is a range of values that are equally
#'    desirable.
#' - `categories()` is for situations where we want to set desirability for
#'    qualitative columns.
#'
#' Except for `categories()`, these functions have arguments `low` and `high` to
#' set the ranges of the metrics. For example, using:
#'
#' \preformatted{
#'   minimize(rmse, low = 0.1, high = 2.0)
#' }
#'
#' means that values above 2.0 are unacceptable and that an RMSE of 0.1 is the
#' best possible outcome.
#'
#' There is also an argument that can be used to state how important a metric is
#' in the optimization. By default, using `scale = 1` means that desirability
#' linearly changes between `low` and `high`. Using a `scale` value greater
#' than 1 will make it more difficult to satisfy the criterion when suboptimal
#' values are evaluated. Conversely, a value less than one will diminish the
#' influence of that metric. The `categories()` does not have a scaling
#' argument while `target()` has two (`scale_low` and `scale_high`) for ranges
#' on either side of the `target`.
#'
#' Here is an example the optimizes RMSE and the concordance correlation
#' coefficient, with more emphasis on the former:
#'
#' \preformatted{
#'   minimize(rmse, low = 0.10, high = 2.00, scale = 3.0),
#'   maximize(ccc,  low = 0.00, high = 1.00) # scale defaults to 1.0
#' }
#'
#' If `low`, `high`, or `target` are not specified, the observed data are used
#' to estimate their values. For the previous example, if we were to use
#'
#' \preformatted{
#'   minimize(rmse, low = 0.10, high = 2.00, scale = 3.0),
#'   maximize(ccc)
#' }
#'
#' and the concordance correlation coefficient statistics ranged from 0.21 to
#' 0.35, the actual goals would  end up as:
#'
#' \preformatted{
#'   minimize(rmse, low = 0.10, high = 2.00, scale = 3.0),
#'   maximize(ccc,  low = 0.21, high = 0.35)
#' }
#'
#' More than one variable can be used in a term as long as R can parse and
#' execute the expression. For example, you could define the Youden's J
#' statistic using
#'
#' \preformatted{
#'   maximize(sensitivity + specificity - 1)
#' }
#'
#' (although there is a function for this metric in the \pkg{yardstick} package).
#'
#' We advise not referencing global values or inline functions inside of these
#' verbs.
#'
#' Also note that there may be more than `n` values returned when showing the
#' results; there may be more than one model configuration that has identical
#' overall desirability.
#' @examples
#' # use pre-tuned results to demonstrate:
#' if (rlang::is_installed("tune")) {
#'   library(tune)
#'
#'   show_best_desirability(
#'     ames_iter_search,
#'     maximize(rsq),
#'     minimize(rmse, scale = 3)
#'   )
#'
#'   select_best_desirability(
#'     ames_iter_search,
#'     maximize(rsq),
#'     minimize(rmse, scale = 3)
#'   )
#' }
#'
#' @export
show_best_desirability <- function(x, ..., n = 5, eval_time = NULL) {
  rlang::check_installed("tune")
  mtr_set <- tune::.get_tune_metrics(x)
  mtr_names <- names(rlang::env_get(environment(mtr_set), "fns"))

  mtr <- tune::collect_metrics(x, type = "wide")
  # TODO filter on eval_time

  res <- desirability(..., .use_data = TRUE)

  # Check for correct metric names
  d_vars <- sort(unique(unlist(res@variables)))
  extra_vars <- setdiff(d_vars, mtr_names)
  num_extras <- length(extra_vars)
  if (num_extras > 0) {
    cli::cli_abort(
      "The desirability specification includes {num_extras} performance
            metric{?s} that {?was/were} not collected: {.val {extra_vars}}."
    )
  }

  # Make individual scores:
  d_nms <- make_col_names(res)
  for (i in seq_along(res@translated)) {
    tmp <- try(rlang::eval_tidy(res@translated[[i]], mtr), silent = TRUE)
    if (inherits(tmp, "try-error")) {
      cli::cli_abort("An error occured when computing a desirability score: {tmp}.")
    }
    mtr[[d_nms[i]]] <- tmp
  }

  mtr <-
    mtr |>
    dplyr::mutate(
      .d_overall = d_overall(dplyr::across(dplyr::starts_with(".d_")))
    ) |>
    dplyr::slice_max(.d_overall, n = n, with_ties = TRUE)
  mtr
}

make_col_names <- function(x) {
  vars <- purrr::map_chr(x@variables, ~ paste0(.x, collapse = "_"))
  fns <- purrr::map_chr(x@translated, ~ rlang::expr_deparse(.x[[1]]))
  res <- purrr::map2_chr(fns, vars, ~ paste0(".", .x, "_", .y))
  make.names(res, unique = TRUE)
}

#' @rdname show_best_desirability
#' @export
select_best_desirability <- function(x, ..., eval_time = NULL) {
  p_names <- tune::.get_tune_parameter_names(x)
  res <- show_best_desirability(x, ..., n = 1)
  res |>
    dplyr::select(
      dplyr::all_of(c(p_names, ".config")),
      dplyr::any_of(".eval_time")
    ) |>
    # in case of ties
    dplyr::slice(1)
}
