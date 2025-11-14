# Make desirability columns from a desirability object

Make desirability columns from a desirability object

## Usage

``` r
make_desirability_cols(x, dat, call = rlang::caller_env())
```

## Arguments

- x:

  An object produced by
  [`desirability()`](https://desirability2.tidymodels.org/dev/reference/desirability.md)

- dat:

  A data frame

- call:

  The execution environment of a currently running function.

## Value

An updated version of `dat`
