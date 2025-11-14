# Determine overall desirability

Once desirability columns have been created, determine the overall
desirability using a mean (geometric by default).

## Usage

``` r
d_overall(..., geometric = TRUE, tolerance = 0)
```

## Arguments

- ...:

  One or more unquoted expressions separated by commas. To choose
  multiple columns using selectors,
  [`dplyr::across()`](https://dplyr.tidyverse.org/reference/across.html)
  can be used (see the example below).

- geometric:

  A logical for whether the geometric or arithmetic mean should be used
  to summarize the columns.

- tolerance:

  A numeric value where values strictly less than this value are capped
  at the value. For example, if users wish to use the geometric mean
  without completely excluding settings, a value greater than zero can
  be used.

## Value

A numeric vector.

## See also

[`d_max()`](https://desirability2.tidymodels.org/dev/reference/inline_desirability.md)

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

# Choose model tuning parameters that minimize the number of predictors used
# while maximizing the area under the ROC curve.

classification_results |>
  mutate(
    d_feat = d_min(num_features, 1, 200),
    d_roc  = d_max(roc_auc, 0.5, 0.9),
    d_all  = d_overall(across(starts_with("d_")))
  ) |>
  arrange(desc(d_all))
#> # A tibble: 300 × 9
#>    mixture penalty mn_log_loss pr_auc roc_auc num_features d_feat d_roc
#>      <dbl>   <dbl>       <dbl>  <dbl>   <dbl>        <int>  <dbl> <dbl>
#>  1   0.667 0.0149        0.201  0.463   0.858           14  0.935 0.896
#>  2   0.889 0.0149        0.204  0.461   0.852           11  0.950 0.880
#>  3   1     0.0149        0.205  0.462   0.850           10  0.955 0.875
#>  4   1     0.0117        0.202  0.461   0.854           12  0.945 0.884
#>  5   0.667 0.0189        0.204  0.462   0.853           12  0.945 0.883
#>  6   0.889 0.0117        0.201  0.464   0.857           14  0.935 0.893
#>  7   1     0.00924       0.200  0.465   0.859           15  0.930 0.897
#>  8   1     0.0189        0.208  0.459   0.844            7  0.970 0.859
#>  9   0.778 0.0189        0.205  0.461   0.850           11  0.950 0.876
#> 10   0.556 0.0189        0.202  0.463   0.858           15  0.930 0.894
#> # ℹ 290 more rows
#> # ℹ 1 more variable: d_all <dbl>

# Bias the ranking toward minimizing features by using a larger scale.

classification_results |>
  mutate(
    d_feat = d_min(num_features, 1, 200, scale = 3),
    d_roc  = d_max(roc_auc, 0.5, 0.9),
    d_all  = d_overall(across(starts_with("d_")))
  ) |>
  arrange(desc(d_all))
#> # A tibble: 300 × 9
#>    mixture penalty mn_log_loss pr_auc roc_auc num_features d_feat d_roc
#>      <dbl>   <dbl>       <dbl>  <dbl>   <dbl>        <int>  <dbl> <dbl>
#>  1   1      0.0189       0.208  0.459   0.844            7  0.912 0.859
#>  2   1      0.0240       0.213  0.452   0.835            6  0.927 0.837
#>  3   0.778  0.0240       0.209  0.459   0.844            8  0.898 0.859
#>  4   0.667  0.0304       0.211  0.457   0.842            8  0.898 0.855
#>  5   0.889  0.0240       0.210  0.456   0.841            8  0.898 0.852
#>  6   0.778  0.0304       0.213  0.452   0.835            7  0.912 0.839
#>  7   0.889  0.0304       0.216  0.448   0.830            6  0.927 0.826
#>  8   0.556  0.0386       0.213  0.455   0.840            8  0.898 0.850
#>  9   1      0.0149       0.205  0.462   0.850           10  0.870 0.875
#> 10   0.667  0.0386       0.216  0.449   0.833            7  0.912 0.832
#> # ℹ 290 more rows
#> # ℹ 1 more variable: d_all <dbl>
```
