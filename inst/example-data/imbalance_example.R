#' Imbalanced classification results
#'
#' This is an object produced by [tune::tune_grid()] for a classification data
#' set with a moderate class imbalance (18%) in the first class. The data were
#' simulated. The code to produce the data and analysis is in the source
#' package’s `inst` directory.
#'
#' The model was a single-layer neural network with six tuning parameters
#' chosen for optimization. One parameter, `class_weights,` controls how much
#' influence the minority class has on the objective function during training.
#' This can help trade off the true positive and true negative rates to our
#' needs.
#'
#' The goal would be to have good calibration (as measured by `brier_class`)
#' and improved `sensitivity`, but not without a significant loss of
#' `specificity`.

library(tidymodels)
library(desirability2)
library(future)

# ------------------------------------------------------------------------------

tidymodels_prefer()
theme_set(theme_bw())
options(pillar.advice = FALSE, pillar.min_title_chars = Inf)
plan("multisession")

# ------------------------------------------------------------------------------

set.seed(1)
dat <- sim_classification(num_samples = 1000, intercept = -10)
split <- initial_split(dat, strata = class)
tr_dat <- training(split)
rs <- vfold_cv(tr_dat)

# ------------------------------------------------------------------------------

# fmt: skip
cls_mtr <- metric_set(kap, brier_class, roc_auc, pr_auc, sensitivity, specificity,
                      mn_log_loss, mcc)

# ------------------------------------------------------------------------------

mlp_spec <-
  mlp(
    hidden_units = tune(),
    penalty = tune(),
    learn_rate = tune(),
    epochs = 500,
    activation = tune()
  ) |>
  set_engine("brulee", stop_iter = tune(), class_weights = tune()) |>
  set_mode("classification")

rec <- recipe(class ~ ., data = tr_dat) |>
  step_normalize()

mlp_wflow <- workflow(rec, mlp_spec)

mlp_param <-
  mlp_wflow |>
  extract_parameter_set_dials() |>
  update(
    learn_rate = learn_rate(c(-4, -1/2)),
    class_weights = class_weights(c(1, 20))
  )

set.seed(2)
imbalance_example <-
  mlp_wflow |>
  tune_grid(
    resamples = rs,
    grid = 50,
    metrics = cls_mtr,
    param_info = mlp_param
  )
