#' Desirability functions for selected data columns
#'
#' These functions conducts the same desirability computations on multiple
#' columns of a data set.
#'
#' @inheritParams inline_desirability
#' @param .data A data frame or data frame extension (e.g. a tibble).
#' @param ... One or more unquoted expressions separated by commas (such as
#' `dplyr` selector functions). Variable names can be used as if they were
#' positions in the data frame, so expressions like `x:y` can be used to select
#' a range of variables.
#' @return A tibble containing the select columns and their desirability scores.
#' A prefix is added to the column names based on the type of desirability
#' function (e.g., column `x` becomes column `d_max_x` when used with
#' `d_max_select()`).
#' @export
#' @name selected_desirability
#' @examples
#' library(dplyr)
#'
#' set.seed(1)
#' tibble(x = sort(runif(10)), y = sort(runif(10)), z = 1:10) %>%
#'   d_max_select(x, y, low = 0.5, high = 0.75)
d_max_select <- function(.data, ..., low, high, scale = 1, missing = 1) {
  loc <- tidyselect::eval_select(rlang::expr(c(...)), .data, strict = TRUE, allow_rename = FALSE)
  vars <- names(.data)[loc]
  res <-
    purrr::map_dfc(
      .data[, loc, drop = FALSE],
      d_max,
      low = low,
      high = high,
      scale = scale,
      missing = missing
    )
  names(res) <- paste0("d_max_", names(res))
  if (!tibble::is_tibble(res)) {
    res <- tibble::as_tibble(res)
  }
  res
}

