#' Desirability functions for in-line computations
#'
#' @description
#'
#' Desirability functions map some input to a `[0, 1]` scale where zero is
#' unacceptable and one is most desirable. The mapping depends on the situation.
#' `d_max()` increases desirability with the input while `d_min()` does the
#' opposite.
#'
#' Currently, only the desirability functions defined by Derringer and Suich
#' (1980) are implemented.
#'
#' @param x A vector of data to compute the desirability function
#' @param low,high Single numeric values that define the active ranges of
#' desirability.
#' @param scale A single numeric value to rescale the desirability function.
#' @param missing A single numeric value on `[0, 1]` (or `NA_real_`) that
#' defines how missing values in `x` are mapped to the desirability score.
#' @return A numeric vector on `[0, 1]` where larger values are more
#' desirable.
#' @seealso [d_max_select()]
#' @references Derringer, G. and Suich, R. (1980), Simultaneous Optimization of
#' Several Response Variables. _Journal of Quality Technology_, 12, 214-219.
#' @export
#' @name inline_desirability
#' @examples
#' library(dplyr)
#' library(ggplot2)
#'
#' set.seed(1)
#' dat <- tibble(x = sort(runif(10)), y = sort(runif(10)))
#' d_max(dat$x, 0.1, 0.75)
#'
#' dat %>%
#'   mutate(d_x = d_max(x, 0.1, 0.75))
#'
#' set.seed(2)
#' tibble(z = sort(runif(100))) %>%
#'   mutate(
#'     no_scale = d_max(z, 0.1, 0.75),
#'     easier   = d_max(z, 0.1, 0.75, scale = 1/2)
#'   ) %>%
#'   ggplot(aes(x = z)) +
#'   geom_point(aes(y = no_scale)) +
#'   geom_line(aes(y = no_scale), alpha = .5) +
#'   geom_point(aes(y = easier), col = "blue") +
#'   geom_line(aes(y = easier), col = "blue", alpha = .5) +
#'   lims(x = 0:1, y = 0:1) +
#'   coord_fixed() +
#'   ylab("Desirability")
d_max <- function(x, low, high, scale = 1, missing = 1) {
  .comp_max(x, low, high, scale, missing)
}
