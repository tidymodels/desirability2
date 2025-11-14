# Investigate best tuning parameters

Analogs to
[`tune::show_best()`](https://tune.tidymodels.org/reference/show_best.html)
and
[`tune::select_best()`](https://tune.tidymodels.org/reference/show_best.html)
that can simultaneously optimize multiple metrics or characteristics
using desirability functions.

## Usage

``` r
show_best_desirability(x, ..., n = 5, eval_time = NULL)

select_best_desirability(x, ..., eval_time = NULL)
```

## Arguments

- x:

  The results of
  [`tune_grid()`](https://tune.tidymodels.org/reference/tune_grid.html)
  or
  [`tune_bayes()`](https://tune.tidymodels.org/reference/tune_bayes.html).

- ...:

  One or more desirability selectors to configure the optimization.

- n:

  An integer for the number of top results/rows to return.

- eval_time:

  A single numeric time point where dynamic event time metrics should be
  chosen (e.g., the time-dependent ROC curve, etc). The values should be
  consistent with the values used to create `x`. The `NULL` default will
  automatically use the first evaluation time used by `x`.

## Value

`show_best_desirability()` returns a tibble with `n` rows while
`select_best_desirability()` returns a single row. When showing the
results, the metrics are presented in "wide format" (one column per
metric) and there are new columns for the corresponding desirability
values (each starts with `.d_`).

## Details

Desirability functions might help when selecting the best model based on
more than one performance metric. The user creates a desirability
function to map values of a metric to a `[0, 1]` range where 1.0 is most
desirable and zero is unacceptable. After constructing these for the
metric of interest, the overall desirability is computed using the
geometric mean of the individual desirabilities.

The verbs that can be used in `...` (and their arguments) are:

- [`maximize()`](https://desirability2.tidymodels.org/dev/reference/aliases.md)
  when larger values are better, such as the area under the ROC score.

- [`minimize()`](https://desirability2.tidymodels.org/dev/reference/aliases.md)
  for metrics such as RMSE or the Brier score.

- [`target()`](https://desirability2.tidymodels.org/dev/reference/aliases.md)
  for cases when a specific value of the metric is important.

- [`constrain()`](https://desirability2.tidymodels.org/dev/reference/aliases.md)
  is used when there is a range of values that are equally desirable.

- `categories()` is for situations where we want to set desirability for
  qualitative columns.

Except for `categories()`, these functions have arguments `low` and
`high` to set the ranges of the metrics. For example, using:

      minimize(rmse, low = 0.1, high = 2.0)

means that values above 2.0 are unacceptable and that an RMSE of 0.1 is
the best possible outcome.

There is also an argument that can be used to state how important a
metric is in the optimization. By default, using `scale = 1` means that
desirability linearly changes between `low` and `high`. Using a `scale`
value greater than 1 will make it more difficult to satisfy the
criterion when suboptimal values are evaluated. Conversely, a value less
than one will diminish the influence of that metric. The `categories()`
does not have a scaling argument while
[`target()`](https://desirability2.tidymodels.org/dev/reference/aliases.md)
has two (`scale_low` and `scale_high`) for ranges on either side of the
`target`.

Here is an example that optimizes RMSE and the concordance correlation
coefficient (a.k.a. "ccc"), with more emphasis on the former:

      minimize(rmse, low = 0.10, high = 2.00, scale = 3.0),
      maximize(ccc,  low = 0.00, high = 1.00) # scale defaults to 1.0

If `low`, `high`, or `target` are not specified, the observed data are
used to estimate their values. For the previous example, if we were to
use

      minimize(rmse, low = 0.10, high = 2.00, scale = 3.0),
      maximize(ccc)

and the concordance correlation coefficient statistics ranged from 0.21
to 0.35, the actual goals would end up as:

      minimize(rmse, low = 0.10, high = 2.00, scale = 3.0),
      maximize(ccc,  low = 0.21, high = 0.35)

More than one variable can be used in a term as long as R can parse and
execute the expression. For example, you could define the Youden's J
statistic using

      maximize(sensitivity + specificity - 1)

(although there is a function for this metric in the yardstick package).

If the columns of the data set have missing values, their corresponding
desirability will be missing. The overall desirability computation
excludes missing values.

We advise not referencing global values or inline functions inside of
these verbs.

Also note that there may be more than `n` values returned when showing
the results; there may be more than one model configuration that has
identical overall desirability.

## References

Derringer, G. and Suich, R. (1980), Simultaneous Optimization of Several
Response Variables. *Journal of Quality Technology*, 12, 214-219.

Bartz-Beielstein, T. (2025). Multi-Objective Optimization and
Hyperparameter Tuning With Desirability Functions. arXiv preprint
arXiv:2503.23595.

## See also

[`d_max()`](https://desirability2.tidymodels.org/dev/reference/inline_desirability.md),
[`d_overall()`](https://desirability2.tidymodels.org/dev/reference/d_overall.md)

## Examples

``` r
# use pre-tuned results to demonstrate:
if (rlang::is_installed("tune")) {

  show_best_desirability(
    tune::ames_iter_search,
    maximize(rsq),
    minimize(rmse, scale = 3)
  )

  select_best_desirability(
    tune::ames_iter_search,
    maximize(rsq),
    minimize(rmse, scale = 3)
  )
}
#> # A tibble: 1 × 6
#>       K weight_func dist_power   lon   lat .config          
#>   <int> <chr>            <dbl> <int> <int> <chr>            
#> 1    33 triweight        0.511    10     3 pre08_mod07_post0
```
