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
#' @examples
#' library(dplyr)
#'
#' # Choose model tuning parameters that minimize the number of predictors used
#' # while maximizing the area under the ROC curve.
#'
#' classification_results %>%
#'   mutate(
#'     d_feat = d_min(num_features, 1, 200),
#'     d_roc  = d_max(roc_auc, 0.5, 0.9),
#'     d_all  = d_overall(across(starts_with("d_")))
#'   ) %>%
#'   arrange(desc(d_all))
#'
#' # Bias the ranking toward minimizing features by using a larger scale.
#'
#' classification_results %>%
#'   mutate(
#'     d_feat = d_min(num_features, 1, 200, scale = 3),
#'     d_roc  = d_max(roc_auc, 0.5, 0.9),
#'     d_all  = d_overall(across(starts_with("d_")))
#'   ) %>%
#'   arrange(desc(d_all))

d_overall <- function(..., geometric = TRUE, tolerance = 0) {
  vals <- purrr::map_dfc(list(...), I)
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

geomean <- function(x, na.rm = TRUE) {
  if (any(x[!is.na(x)] <= 0)) {
    return(0)
  }
  exp(sum(log(x), na.rm = na.rm) / sum(!is.na(x)))
}

