# High-level interface to specifying desirability functions

High-level interface to specifying desirability functions

## Usage

``` r
desirability(..., .use_data = TRUE)
```

## Arguments

- ...:

  using a goal function (see below) and the variable to be optimized.
  Other arguments should be specified as needed but **must be named**.
  Order of the arguments does not matter.

- .use_data:

  A single logical to specify whether all translated desirability
  functions (such as
  [`d_max()`](https://desirability2.tidymodels.org/dev/reference/inline_desirability.md))
  should enable `use_data = TRUE` to fill in any unspecified required
  arguments.

## Value

An object of class `"desirability_set"` that can be used to make a set
of desirability functions.

## Details

The following set of nonexistent functions are used to specify an
optimization goal:

- [`maximize()`](https://desirability2.tidymodels.org/dev/reference/aliases.md)
  (corresponding to
  [`d_max()`](https://desirability2.tidymodels.org/dev/reference/inline_desirability.md))

- [`minimize()`](https://desirability2.tidymodels.org/dev/reference/aliases.md)
  ([`d_min()`](https://desirability2.tidymodels.org/dev/reference/inline_desirability.md))

- [`target()`](https://desirability2.tidymodels.org/dev/reference/aliases.md)
  ([`d_target()`](https://desirability2.tidymodels.org/dev/reference/inline_desirability.md))

- [`constrain()`](https://desirability2.tidymodels.org/dev/reference/aliases.md)
  ([`d_box()`](https://desirability2.tidymodels.org/dev/reference/inline_desirability.md))

- `categories()`
  ([`d_max()`](https://desirability2.tidymodels.org/dev/reference/inline_desirability.md))

For example, if you wanted to jointly maximize a regression model’s
Rsquared while minimizing the RMSE, you could use

      desirability(
        minimize(rmse, scale = 3),
        maximize(rsq)
     )

Where the `scale` argument makes the desirability curve more stringent.
