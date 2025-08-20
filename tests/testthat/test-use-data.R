test_that('using data for bounds', {

  expect_equal(
    d_max(dat, low = mn, high = 2),
    d_max(dat, high = 2, use_data = TRUE)
  )
  expect_equal(
    d_max(dat, low = 0, high = mx),
    d_max(dat, low = 0, use_data = TRUE)
  )
  expect_snapshot(d_max(dat, high = 2), error = TRUE)
  expect_snapshot(d_max(dat, low = 2), error = TRUE)

  # ----------------------------------------------------------------------------

  expect_equal(
    d_min(dat, low = mn, high = 2),
    d_min(dat, high = 2, use_data = TRUE)
  )
  expect_equal(
    d_min(dat, low = 0, high = mx),
    d_min(dat, low = 0, use_data = TRUE)
  )
  expect_snapshot(d_min(dat, high = 2), error = TRUE)
  expect_snapshot(d_min(dat, low = 2), error = TRUE)

  # ----------------------------------------------------------------------------

  expect_equal(
    d_box(dat, low = mn, high = 2),
    d_box(dat, high = 2, use_data = TRUE)
  )
  expect_equal(
    d_box(dat, low = 0, high = mx),
    d_box(dat, low = 0, use_data = TRUE)
  )
  expect_snapshot(d_box(dat, high = 2), error = TRUE)
  expect_snapshot(d_box(dat, low = 2), error = TRUE)

  # ----------------------------------------------------------------------------

  expect_equal(
    d_target(dat, low = mn, high = 2, target = 1),
    d_target(dat, high = 2, target = 1, use_data = TRUE)
  )
  expect_equal(
    d_target(dat, low = -1, high = 2, target = md),
    d_target(dat, low = -1, high = 2, use_data = TRUE)
  )
  expect_equal(
    d_target(dat, low = -1, target = 2, high = mx),
    d_target(dat, low = -1, target = 2, use_data = TRUE)
  )
  expect_snapshot(d_target(dat, target = 2, high = 2), error = TRUE)
  expect_snapshot(d_target(dat, low = 2, high = 2), error = TRUE)
  expect_snapshot(d_target(dat, low = 2, target = 2), error = TRUE)

})

test_that('infinite values in data', {

  dat_inf <- dat
  dat_inf[1] <- Inf
  dat_inf[2] <- -Inf

  expect_equal(
    d_max(dat_inf, low = min(dat_inf[-(1:2)]), high = 2),
    d_max(dat_inf, high = 2, use_data = TRUE)
  )
})


test_that('constant values in data', {

  dat_same <- rep(.1, 10)

  expect_equal(
    d_max(dat_same, use_data = TRUE),
    rep(1/2, length(dat_same))
  )
  expect_equal(
    d_min(dat_same, use_data = TRUE),
    rep(1/2, length(dat_same))
  )
  expect_equal(
    d_box(dat_same, use_data = TRUE),
    rep(1.0, length(dat_same))
  )

})

