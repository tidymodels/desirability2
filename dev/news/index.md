# Changelog

## desirability2 (development version)

## desirability2 0.2.0

CRAN release: 2025-08-22

- Export a helper function (`make_desirability_cols;;d()`) to make it
  easier for other packages to import and use desirability2.

- The `.use_data` default for
  [`desirability()`](https://desirability2.tidymodels.org/dev/reference/desirability.md)
  was changed to `TRUE`.

- When `use_data = TRUE` is used in the individual desirability
  functions

  - Infinite values are ignored when computing limits.
  - The estimated low and/or high values are nudged in different
    directions to avoid them having the same value.

## desirability2 0.1.0

CRAN release: 2025-07-22

- Transition from the magrittr pipe to the base R pipe.

- Added a developer oriented function,
  [`desirability()`](https://desirability2.tidymodels.org/dev/reference/desirability.md),
  that can be used as a user-facing API for methods.

- Two new functions to support the tune package were added.
  [`select_best_desirability()`](https://desirability2.tidymodels.org/dev/reference/show_best_desirability.md)
  and
  [`show_best_desirability()`](https://desirability2.tidymodels.org/dev/reference/show_best_desirability.md)
  can be used for multiparameter optimization of tuning parameters.

## desirability2 0.0.1

CRAN release: 2023-05-11

- Added a `NEWS.md` file to track changes to the package.
