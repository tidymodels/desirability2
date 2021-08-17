

test_that('D&E examples page 218', {
  expect_equal(d_max(129.5, 120, 170), .189, tolerance = .01)           # pico
  expect_equal(d_max(1300, 1000, 1300), 1, tolerance = .01)             # modulus
  # expect_equal(d_target(465.7, 400, 500, 600), 0.656, tolerance = .01)  # elongation
  # expect_equal(d_target(68, 67.5, 75), 0.932, tolerance = .01)          # hardness
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

})

test_that('missing values', {
  expect_equal(d_max(NA, 1, 2, missing = NA_real_), NA_real_)
  expect_equal(d_max(NA, 1, 2, missing = .1), .1)

  expect_equal(d_min(NA, 1, 2, missing = NA_real_), NA_real_)
  expect_equal(d_min(NA, 1, 2, missing = .1), .1)

})
