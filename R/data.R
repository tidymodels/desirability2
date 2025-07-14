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

#' Imbalanced classification results
#'
#' This is an object produced by [tune::tune_grid()] for a classification data
#' set with a moderate class imbalance (18%) in the first class. The data were
#' simulated. The code to produce the data and analysis is in the source
#' package’s `inst` directory.
#'
#' The model was a single-layer neural network with six tuning parameters
#' chosen for optimization. One parameter, `class_weights,` controls how much
#' influence the minority class has on the objective function during training.
#' This can help trade off the true positive and true negative rates to our
#' needs.
#'
#' The goal would be to have good calibration (as measured by `brier_class`)
#' and improved `sensitivity`, but not without a significant loss of
#' `specificity`.
#'
#' @name imbalance_example
#' @aliases imbalance_example
#' @docType data
#' @return \item{imbalance_example}{an object with class `tune_results`}
#' @keywords datasets
NULL
