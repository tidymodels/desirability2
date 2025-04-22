#' Determine overall desirability
#'
#' Once desirability columns have been created, determine the overall
#' desirability using a mean (geometric by default).
#'
#' @param ... One or more unquoted expressions separated by commas. To choose
#' multiple columns using selectors, [dplyr::across()] can be used (see the
#' example below).
#' @param geometric A logical for whether the geometric or arithmetic mean
#' should be used to summarize the columns.
#' @param tolerance A numeric value where values strictly less than this value
#' are capped at the value. For example, if users wish to use the geometric mean
#' without completely excluding settings, a value greater than zero can be used.
#' @return A numeric vector.
#' @seealso [d_max()]
#' @export
#' @examplesIf rlang::is_installed("dplyr")
#' library(dplyr)
#'
#' # Choose model tuning parameters that minimize the number of predictors used
#' # while maximizing the area under the ROC curve.
#'
#' classification_results |>
#'   mutate(
#'     d_feat = d_min(num_features, 1, 200),
#'     d_roc  = d_max(roc_auc, 0.5, 0.9),
#'     d_all  = d_overall(across(starts_with("d_")))
#'   ) |>
#'   arrange(desc(d_all))
#'
#' # Bias the ranking toward minimizing features by using a larger scale.
#'
#' classification_results |>
#'   mutate(
#'     d_feat = d_min(num_features, 1, 200, scale = 3),
#'     d_roc  = d_max(roc_auc, 0.5, 0.9),
#'     d_all  = d_overall(across(starts_with("d_")))
#'   ) |>
#'   arrange(desc(d_all))

d_overall <- function(..., geometric = TRUE, tolerance = 0) {
  d_lst <- list(...)
  d_lst <- maybe_name(d_lst)
  vals <- dplyr::bind_cols(d_lst)
  is_d_input(vals, call = rlang::current_call())
  if (ncol(vals) == 1) {
    return(vals[[1]])
  }
  vals <- as.matrix(vals)
  if (tolerance > 0) {
    vals[vals < tolerance] <- tolerance
  }
  if (geometric) {
    res <- apply(vals, 1, geomean)
  } else {
    res <- apply(vals, 1, mean, na.rm = TRUE)
  }
  res
}

maybe_name <- function(x) {
  # The selector can return vectors (unnamed) and data frames.
  # Binding unnamed things generates a warning so add names here when needed.
  is_tbl <- purrr::map_lgl(x, is.data.frame)
   if (all(is_tbl)) {
     return(x)
   }
  if (any(!is_tbl)) {
    if (any(is_tbl)) {
      df_x <- x[is_tbl]
    }
    x <- x[!is_tbl]
    names(x) <- paste0("d_", which(!is_tbl))
    if (any(is_tbl)) {
      x <- c(x, df_x)
    }
  }
  x
}

geomean <- function(x, na.rm = TRUE) {
  if (any(x[!is.na(x)] <= 0)) {
    return(0)
  }
  exp(sum(log(x), na.rm = na.rm) / sum(!is.na(x)))
}

