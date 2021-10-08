suppressPackageStartupMessages(library(dplyr, quietly = TRUE))

res <-
  classification_results %>%
  mutate(
    d_feat = d_min(num_features, 1, 200),
    d_roc  = d_max(roc_auc, 0.5, 0.9)
  )

# ------------------------------------------------------------------------------

test_that('D&S examples page 218', {
  expect_equal(d_max(129.5, 120, 170), .189, tolerance = .01)           # pico
  expect_equal(d_max(1300, 1000, 1300), 1, tolerance = .01)             # modulus
  expect_equal(d_target(465.7, 400, 500, 600), 0.656, tolerance = .01)  # elongation
  expect_equal(d_target(68, 60, 67.5, 75), 0.932, tolerance = .01)      # hardness
})


test_that('correct values', {
  x <- seq(0, 1, length.out = 11)

  # ------------------------------------------------------------------------------
  # Expected results form original desirability package. See test-cases dir

  expect_equal(
    d_max(x, .1, .9),
    c(0, 0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1, 1)
  )
  expect_equal(
    d_max(x, 0, 1),
    c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1)
  )
  expect_equal(
    d_max(x, .1, .9, 1/2),
    c(0, 0, 0.3536, 0.5, 0.6124, 0.7071, 0.7906, 0.866, 0.9354, 1, 1),
    tolerance = 0.1
  )
  expect_equal(
    d_max(x, .1, .9, 3),
    c(0, 0, 0.002, 0.0156, 0.0527, 0.125, 0.2441, 0.4219, 0.6699, 1, 1),
    tolerance = 0.1
  )
  expect_error(
    d_max(x, 0, -1),
    "The values should be `low < high`"
  )
  expect_error(
    d_max(x, 0:1, 2),
    "low' should be a single numeric value"
  )
  expect_error(
    d_max(x, 0, 1:2),
    "high' should be a single numeric value"
  )
  expect_error(
    d_max(x, NA_real_, 1:2),
    "low' should be a single numeric value"
  )
  expect_error(
    d_max(x, 0, NA_real_),
    "high' should be a single numeric value"
  )
  # ------------------------------------------------------------------------------

  expect_equal(
    d_min(x, .1, .9),
    c(1, 1, 0.875, 0.75, 0.625, 0.5, 0.375, 0.25, 0.125, 0, 0)
  )
  expect_equal(
    d_min(x, 0, 1),
    c(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0)
  )
  expect_equal(
    d_min(x, .1, .9, 1/2),
    c(1, 1, 0.9354, 0.866, 0.7906, 0.7071, 0.6124, 0.5, 0.3536, 0, 0),
    tolerance = 0.1
  )
  expect_equal(
    d_min(x, .1, .9, 3),
    c(1, 1, 0.6699, 0.4219, 0.2441, 0.125, 0.0527, 0.0156, 0.002, 0, 0),
    tolerance = 0.1
  )
  expect_error(
    d_min(x, 0, -1),
    "The values should be `low < high`"
  )
  expect_error(
    d_min(x, 0:1, 2),
    "low' should be a single numeric value"
  )
  expect_error(
    d_min(x, 0, 1:2),
    "high' should be a single numeric value"
  )
  expect_error(
    d_min(x, NA_real_, 1:2),
    "low' should be a single numeric value"
  )
  expect_error(
    d_min(x, 0, NA_real_),
    "high' should be a single numeric value"
  )

  # ------------------------------------------------------------------------------

  expect_equal(
    d_target(x, .1, .3, .9),
    c(0, 0, 0.5, 1, 0.8333, 0.6667, 0.5, 0.3333, 0.1667, 0, 0),
    tolerance = 0.1
  )
  expect_equal(
    d_target(x, .1, .3, .9, 1/2, 3),
    c(0, 0, 0.7071, 1, 0.5787, 0.2963, 0.125, 0.037, 0.0046, 0, 0),
    tolerance = 0.1
  )
  expect_error(
    d_target(x, 0:1, 2, 3),
    "low' should be a single numeric value"
  )
  expect_error(
    d_target(x, 0, 1:2, 3),
    "target' should be a single numeric value"
  )
  expect_error(
    d_target(x, 0, 1, 2:3),
    "high' should be a single numeric value"
  )
  expect_error(
    d_target(x, NA_real_, 1, 2),
    "low' should be a single numeric value"
  )
  expect_error(
    d_target(x, 0, NA_real_, 1),
    "target' should be a single numeric value"
  )
  expect_error(
    d_target(x, 0, 1, NA_real_),
    "high' should be a single numeric value"
  )
  # ------------------------------------------------------------------------------

  x_points <- (1:5)/5
  d_points <- c(0.36, 0.64, 0.84, 0.96, 1)
  expect_equal(
    d_custom(x, x_points, d_points),
    c(0, 0, 0.36, 0.5, 0.64, 0.74, 0.84, 0.9, 0.96, 0.98, 1),
    tolerance = 0.1
  )
  expect_error(
    d_custom(x, x_points[-1], d_points),
    "'values' and 'd' should be the same length"
  )
  expect_error(
    d_custom(x, x_points, d_points[-1]),
    "'values' and 'd' should be the same length"
  )
  expect_error(
    d_custom(x, letters, d_points),
    "'values' should be a numeric vector"
  )
  expect_error(
    d_custom(x, x_points, letters),
    "Desirability values should be numeric and complete"
  )

  # ------------------------------------------------------------------------------

  expect_equal(
    d_box(x, 0.2, .7),
    c(0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0),
    tolerance = 0.1
  )
  expect_error(
    d_box(x, 0, -1),
    "The values should be `low < high`"
  )
  expect_error(
    d_box(x, 0:1, 2),
    "low' should be a single numeric value"
  )
  expect_error(
    d_box(x, 0, 1:2),
    "high' should be a single numeric value"
  )
  expect_error(
    d_box(x, NA_real_, 1:2),
    "low' should be a single numeric value"
  )
  expect_error(
    d_box(x, 0, NA_real_),
    "high' should be a single numeric value"
  )
  # ------------------------------------------------------------------------------

  lvls <- (1:5)/5
  names(lvls) <- month.abb[2:6]
  expect_equal(
    d_category(month.abb[2:4], lvls),
    c(0.2, 0.4, 0.6)
  )

  # ------------------------------------------------------------------------------

  expect_equal(
    res %>% mutate(d_all  = d_overall(across(starts_with("d_")))) %>% purrr::pluck("d_all"),
    sqrt(res$d_feat * res$d_roc)
  )
  expect_equal(
    res %>% mutate(d_all  = d_overall(d_feat, d_roc)) %>% purrr::pluck("d_all"),
    sqrt(res$d_feat * res$d_roc)
  )
  expect_error(
    res %>% mutate(d_all  = d_overall(across(everything()))),
    "Desirability values should be numeric and complete in the range"
  )


})

test_that('missing values', {
  expect_equal(d_max(NA_real_, 1, 2, missing = NA_real_), NA_real_)
  expect_equal(d_max(NA_real_, 1, 2, missing = .1), .1)

  expect_equal(d_min(NA_real_, 1, 2, missing = NA_real_), NA_real_)
  expect_equal(d_min(NA_real_, 1, 2, missing = .1), .1)

})
