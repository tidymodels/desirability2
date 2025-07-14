#' In-line desirability functions
#'
#' Desirability functions (Derringer and Suich, 1980,
#' \doi{10.1080/00224065.1980.11980968}) can be used for multivariate
#' optimization.
#'
#' See:
#'
#'  - [d_max()] for individual desirability functions.
#'  - [d_overall()] for combining functions into an overall objective function.
#' @keywords internal
"_PACKAGE"

# enable usage of <S7_object>@name in package code
#' @rawNamespace if (getRversion() < "4.3.0") importFrom("S7", "@")
#'
## usethis namespace: start
#' @import rlang
## usethis namespace: end
NULL

utils::globalVariables(".d_overall")
