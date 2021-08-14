library(tidymodels)
library(readr)
tidymodels_prefer()
theme_set(theme_bw())

# ------------------------------------------------------------------------------
# Variation of https://www.tidymodels.org/start/case-study/

hotels <-
  read_csv('https://tidymodels.org/start/case-study/hotels.csv') %>%
  mutate_if(is.character, as.factor)


set.seed(123)
splits      <- initial_split(hotels, strata = children)

hotel_other <- training(splits)
hotel_test  <- testing(splits)

# training set proportions by children
hotel_other %>%
  count(children) %>%
  mutate(prop = n/sum(n))

# test set proportions by children
hotel_test  %>%
  count(children) %>%
  mutate(prop = n/sum(n))

set.seed(234)
val_set <- validation_split(hotel_other,
                            strata = children,
                            prop = 0.80)


lr_reg_grid <-
  crossing(penalty = 10 ^ seq(-4, -1, length.out = 30),
           mixture = seq(0, 1, length = 10))

lr_mod <-
  logistic_reg(penalty = tune(), mixture = tune()) %>%
  set_engine("glmnet", path_values = unique(lr_reg_grid$penalty))

holidays <- c("AllSouls", "AshWednesday", "ChristmasEve", "Easter",
              "ChristmasDay", "GoodFriday", "NewYearsDay", "PalmSunday")

lr_recipe <-
  recipe(children ~ ., data = hotel_other) %>%
  step_date(arrival_date) %>%
  step_holiday(arrival_date, holidays = holidays) %>%
  step_rm(arrival_date) %>%
  step_dummy(all_nominal(), -all_outcomes()) %>%
  step_zv(all_predictors()) %>%
  step_normalize(all_predictors())

lr_workflow <-
  workflow() %>%
  add_model(lr_mod) %>%
  add_recipe(lr_recipe)

glmnet_vars <- function(x) {
  # `x` will be a workflow object
  mod <- extract_fit_engine(x)
  # `df` is the number of model terms for each penalty value
  tibble(penalty = mod$lambda, num_features = mod$df)
}

ctrl <- control_grid(extract = glmnet_vars, verbose = TRUE)

lr_res <-
  lr_workflow %>%
  tune_grid(val_set,
            grid = lr_reg_grid,
            metrics = metric_set(roc_auc, pr_auc, mn_log_loss),
            control = ctrl)

metrics <-
  collect_metrics(lr_res) %>%
  select(-.estimator, -n, -std_err) %>%
  pivot_wider(names_from = c(.metric), values_from = c(mean))


classification_results <-
  lr_res %>%
  dplyr::select(.extracts) %>%
  unnest(cols = .extracts) %>%
  dplyr::select(-penalty, -.config) %>%
  group_by(mixture) %>%
  slice(1) %>%
  ungroup() %>%
  unnest(cols = .extracts) %>%
  full_join(
    metrics,
    by = c("penalty", "mixture")
  ) %>%
  relocate(num_features, .after = "roc_auc") %>%
  select(-.config)

usethis::use_data(classification_results)



