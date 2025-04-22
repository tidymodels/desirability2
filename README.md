
<!-- README.md is generated from README.Rmd. Please edit that file -->

# desirability2

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/tidymodels/desirability2/branch/main/graph/badge.svg)](https://app.codecov.io/gh/tidymodels/desirability2?branch=main)
[![R-CMD-check](https://github.com/tidymodels/desirability2/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tidymodels/desirability2/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Desirability functions are simple but useful tools for simultaneously
optimizing several things at once. For each input, a translation
function is used to map the input values between zero and one where zero
is unacceptable and one is most desirable.

For example, [Kuhn and Johnson
(2019)](https://bookdown.org/max/FES/genetic-algorithms.html#coercing-sparsity)
use these functions during feature selection to help a genetic algorithm
choose which predictors to include in a model that simultaneously
improves performance and reduces the number of predictors.

The desirability2 package improves on the original [desirability
package](https://cran.r-project.org/package=desirability) by enabling
in-line computations that can be used with dplyr pipelines.

## A ranking example

Suppose a classification model with two tuning parameters (`penalty` and
`mixture`) and several performance measures (multinomial log-loss, area
under the precision-recall curve, and the area under the ROC curve). For
each tuning parameter, the average number of features used in the model
was also computed:

``` r
library(desirability2)
library(dplyr)
classification_results
#> # A tibble: 300 × 6
#>    mixture penalty mn_log_loss pr_auc roc_auc num_features
#>      <dbl>   <dbl>       <dbl>  <dbl>   <dbl>        <int>
#>  1       0  0.1          0.199  0.488   0.869          211
#>  2       0  0.0788       0.196  0.491   0.870          211
#>  3       0  0.0621       0.194  0.494   0.871          211
#>  4       0  0.0489       0.192  0.496   0.872          211
#>  5       0  0.0386       0.191  0.499   0.873          211
#>  6       0  0.0304       0.190  0.501   0.873          211
#>  7       0  0.0240       0.188  0.504   0.874          211
#>  8       0  0.0189       0.188  0.506   0.874          211
#>  9       0  0.0149       0.187  0.508   0.874          211
#> 10       0  0.0117       0.186  0.510   0.874          211
#> # ℹ 290 more rows
```

We might want to pick a model in a way that maximizes the area under the
ROC curve with a minimum number of model terms. We know that the ROC
measures is usually between 0.5 and 1.0. We can define a desirability
function to *maximize* this value using:

``` r
d_max(roc_auc, low = 1/2, high = 1)
```

For the number of terms, if we wanted to minimize this under the
condition that there should be less than 100 features, a minimal
desirability function can be appropriate:

``` r
d_min(num_features, low = 1, high = 100)
```

We can add these as columns to the data using a `mutate()` statement
along with a call to the function that blends these values using a
geometric mean:

``` r
classification_results |> 
  select(-mn_log_loss, -pr_auc) |> 
  mutate(
    d_roc   = d_max(roc_auc, low = 1/2, high = 1), 
    d_terms = d_min(num_features, low = 1, high = 50),
    d_both    = d_overall(d_roc, d_terms)
  ) |> 
  # rank from most desirable to least:
  arrange(desc(d_both))
#> # A tibble: 300 × 7
#>    mixture penalty roc_auc num_features d_roc d_terms d_both
#>      <dbl>   <dbl>   <dbl>        <int> <dbl>   <dbl>  <dbl>
#>  1   1      0.0189   0.844            7 0.687   0.878  0.777
#>  2   1      0.0240   0.835            6 0.670   0.898  0.776
#>  3   0.889  0.0304   0.830            6 0.660   0.898  0.770
#>  4   0.778  0.0240   0.844            8 0.687   0.857  0.768
#>  5   0.778  0.0304   0.835            7 0.671   0.878  0.767
#>  6   0.889  0.0386   0.820            5 0.640   0.918  0.766
#>  7   0.889  0.0489   0.813            4 0.625   0.939  0.766
#>  8   0.667  0.0304   0.842            8 0.684   0.857  0.766
#>  9   0.778  0.0489   0.819            5 0.638   0.918  0.765
#> 10   0.778  0.0621   0.812            4 0.623   0.939  0.765
#> # ℹ 290 more rows
```

See `?inline_desirability` for details on the individual desirability
functions.

## Code of Conduct

Please note that the desirability2 project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## Contributing

This project is released with a [Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

- If you think you have encountered a bug, please [submit an
  issue](https://github.com/tidymodels/desirability2/issues).

- Either way, learn how to create and share a
  [reprex](https://reprex.tidyverse.org/articles/articles/learn-reprex.html)
  (a minimal, reproducible example), to clearly communicate about your
  code.
