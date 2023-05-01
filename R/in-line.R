#' Desirability functions for in-line computations
#'
#' @description
#'
#' Desirability functions map some input to a `[0, 1]` scale where zero is
#' unacceptable and one is most desirable. The mapping depends on the situation.
#' For example, `d_max()` increases desirability with the input while `d_min()`
#' does the opposite. See the plots in the examples to see more examples.
#'
#' Currently, only the desirability functions defined by Derringer and Suich
#' (1980) are implemented.
#'
#' @param x A vector of data to compute the desirability function
#' @param low,high,target Single numeric values that define the active ranges of
#' desirability.
#' @param scale,scale_low,scale_high A single numeric value to rescale the
#' desirability function (each should be great than 0.0). Values >1.0 make the
#' desirability more difficult to satisfy while smaller values make it easier
#' (see the examples below). `scale_low` and  `scale_high` do the same for
#' target functions with `scale_low` affecting the range below the `target`
#' value and `scale_high` affecting values greater than `target`.
#' @param missing A single numeric value on `[0, 1]` (or `NA_real_`) that
#' defines how missing values in `x` are mapped to the desirability score.
#' @param use_data Should the low, middle, and/or high values be derived from
#' the data (`x`) using the minimum, maximum, or median (respectively)?
#' @param x_vals,desirability Numeric vectors of the same length that define the
#' desirability results at specific values of `x`. Values below and above the
#' data in `x_vals` are given values of zero and one, respectively.
#' @param categories A named list of desirability values that match all
#' possible categories to specific desirability values. Data that are not
#' included in `categories` are given the value in `missing`.
#' @return A numeric vector on `[0, 1]` where larger values are more
#' desirable.
#' @details
#' Each function translates the values to desirability on `[0, 1]`.
#'
#' ## Equations
#'
#' ### Maximization
#'
#' - `data > high`: d = 1.0
#' - `data < low`: d = 0.0
#' - `low <= data <= high`: \eqn{d = \left(\frac{data-low}{high-low}\right)^{scale}}
#'
#' ### Minimization
#'
#' - `data > high`: d = 0.0
#' - `data < low`: d = 1.0
#' - `low <= data <= high`: \eqn{d = \left(\frac{data = low}{low - high}\right)^{scale}}
#'
#' ### Target
#'
#' - `data > high`: d = 0.0
#' - `data < low`: d = 0.0
#' - `low <= data <= target`: \eqn{d = \left(\frac{data - low}{target - low}\right)^{scale\_low}}
#' - `target <= data <= high`: \eqn{d = \left(\frac{data - high}{target - high}\right)^{scale\_high}}
#'
#' ### Minimization
#'
#' - `data > high`: d = 0.0
#' - `data < low`: d = 0.0
#' - `low <= data <= high`:d = 1.0
#'
#' ### Categories
#' - `data = level`: d = 1.0
#' - `data != level`: d = 0.0
#'
#' ### Custom
#'
#' For the sequence of values given to the function, `d_custom()` will return
#' the desirability values that correspond to data matching values in `x_vals`.
#' Otherwise, linear interpolation is used for values in-between.
#'
#' @seealso [d_overall()]
#' @references Derringer, G. and Suich, R. (1980), Simultaneous Optimization of
#' Several Response Variables. _Journal of Quality Technology_, 12, 214-219.
#' @export
#' @name inline_desirability
#' @examplesIf rlang::is_installed(c("dplyr", "ggplot2"))
#' library(dplyr)
#' library(ggplot2)
#'
#' set.seed(1)
#' dat <- tibble(x = sort(runif(30)), y = sort(runif(30)))
#' d_max(dat$x[1:10], 0.1, 0.75)
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
#'
#' # ------------------------------------------------------------------------------
#' # Target example
#'
#' dat %>%
#'   mutate(
#'     triangle = d_target(x, 0.1, 0.5, 0.9, scale_low = 2, scale_high = 1/2)
#'   ) %>%
#'   ggplot(aes(x = x, y = triangle)) +
#'   geom_point() +
#'   geom_line(alpha = .5) +
#'   lims(x = 0:1, y = 0:1) +
#'   coord_fixed() +
#'   ylab("Desirability")
#'
#' # ------------------------------------------------------------------------------
#' # Box constraints
#'
#' dat %>%
#'   mutate(box = d_box(x, 1/4, 3/4)) %>%
#'   ggplot(aes(x = x, y = box)) +
#'   geom_point() +
#'   geom_line(alpha = .5) +
#'   lims(x = 0:1, y = 0:1) +
#'   coord_fixed() +
#'   ylab("Desirability")
#'
#' # ------------------------------------------------------------------------------
#' # Custom function
#'
#' v_x <- seq(0, 1, length.out = 20)
#' v_d <- 1 - exp(-10 * abs(v_x - .5))
#'
#' dat %>%
#'   mutate(v = d_custom(x, v_x, v_d)) %>%
#'   ggplot(aes(x = x, y = v)) +
#'   geom_point() +
#'   geom_line(alpha = .5) +
#'   lims(x = 0:1, y = 0:1) +
#'   coord_fixed() +
#'   ylab("Desirability")
#'
#' # ------------------------------------------------------------------------------
#' # Qualitative data
#'
#' set.seed(3)
#' groups <- sort(runif(10))
#' names(groups) <- letters[1:10]
#'
#' tibble(x = letters[1:7]) %>%
#'   mutate(d = d_category(x, groups)) %>%
#'   ggplot(aes(x = x, y = d)) +
#'   geom_bar(stat = "identity") +
#'   lims(y = 0:1) +
#'   ylab("Desirability")
#'
#' # ------------------------------------------------------------------------------
#' # Apply the same function to many columns at once (dplyr > 1.0)
#'
#' dat %>%
#'   mutate(across(c(everything()), ~ d_min(., .2, .6), .names = "d_{col}"))
#'
d_max <- function(x, low, high, scale = 1, missing = NA_real_, use_data = FALSE) {
  low  <- check_args(low,  x, use_data, fn = "d_max")
  high <- check_args(high, x, use_data, fn = "d_max", type = "high")

  .comp_max(x, low, high, scale, missing)
}

#' @rdname inline_desirability
#' @export
d_min <- function(x, low, high, scale = 1, missing = NA_real_, use_data = FALSE) {
  low  <- check_args(low,  x, use_data, fn = "d_min")
  high <- check_args(high, x, use_data, fn = "d_min", type = "high")
  .comp_min(x, low, high, scale, missing)
}


#' @rdname inline_desirability
#' @export
d_target <- function(x, low, target, high, scale_low = 1, scale_high = 1,
                     missing = NA_real_, use_data = FALSE) {
  low    <- check_args(low,    x, use_data, fn = "d_target")
  high   <- check_args(high,   x, use_data, fn = "d_target", type = "high")
  target <- check_args(target, x, use_data, fn = "d_target", type = "target")

  .comp_target(x, low, target, high, scale_low, scale_high, missing)
}


#' @rdname inline_desirability
#' @export
d_box <- function(x, low, high, missing = NA_real_, use_data = FALSE) {
  low  <- check_args(low,  x, use_data, fn = "d_box")
  high <- check_args(high, x, use_data, fn = "d_box", type = "high")
  .comp_box(x, low, high, missing)
}

#' @rdname inline_desirability
#' @export
d_custom <- function(x, x_vals, desirability, missing = NA_real_) {
  .comp_custom(x, x_vals, desirability, missing)
}


#' @rdname inline_desirability
#' @export
d_category <- function(x, categories, missing = NA_real_) {
  .comp_category(x, categories, missing)
}
