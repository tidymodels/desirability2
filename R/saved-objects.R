d_max_define <- function(.data, ..., low, high, scale = 1, missing = 1) {
  loc <- tidyselect::eval_select(rlang::expr(c(...)), .data, strict = TRUE, allow_rename = FALSE)
  vars <- names(.data)[loc]
  structure(
    list(vars = vars, low = low, high = high, scale = scale, missing = missing),
    class = c("d_max", "desirability")
  )
}

