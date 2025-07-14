#' Classification results
#'
#' These data are a variation of a case study at `tidymodels.org` where a
#'  penalized regression model was used for a binary classification task. The
#'  outcome metrics in `classification_results` are the areas under the ROC and
#'  PR curve, log-likelihood, and the number of predictors selected for a given
#'  amount of penalization. Two tuning parameters, `mixture` and `penalty`, were
#'  varied across 300 conditions.
#'
#'
#' @name classification_results
#' @aliases classification_results
#' @docType data
#' @return \item{classification_results}{a tibble}
#' @keywords datasets
#' @source
#' See the `example-data` directory in the package with code that is a variation
#' of the analysis shown at \url{https://www.tidymodels.org/start/case-study/}.
#' @examples
#'
#' data(classification_results)
NULL
