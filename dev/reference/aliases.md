# Aliases for individual desirability functions

Aliases for individual desirability functions

## Usage

``` r
maximize(x, low, high, scale = 1, missing = NA_real_, use_data = FALSE)

minimize(x, low, high, scale = 1, missing = NA_real_, use_data = FALSE)

target(
  x,
  low,
  target,
  high,
  scale_low = 1,
  scale_high = 1,
  missing = NA_real_,
  use_data = FALSE
)

constrain(x, low, high, missing = NA_real_, use_data = FALSE)

category(x, categories, missing = NA_real_)
```

## Arguments

- x:

  A vector of data to compute the desirability function

- low, high, target:

  Single numeric values that define the active ranges of desirability.

- scale, scale_low, scale_high:

  A single numeric value to rescale the desirability function (each
  should be great than 0.0). Values \>1.0 make the desirability more
  difficult to satisfy while smaller values make it easier (see the
  examples below). `scale_low` and `scale_high` do the same for target
  functions with `scale_low` affecting the range below the `target`
  value and `scale_high` affecting values greater than `target`.

- missing:

  A single numeric value on `[0, 1]` (or `NA_real_`) that defines how
  missing values in `x` are mapped to the desirability score.

- use_data:

  Should the low, middle, and/or high values be derived from the data
  (`x`) using the minimum, maximum, or median (respectively)?

- categories:

  A named vector of desirability values that match all possible
  categories to specific desirability values. Data that are not included
  in `categories` are given the value in `missing`.
