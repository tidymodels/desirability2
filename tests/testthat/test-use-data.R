

set.seed(1)
dat <- rnorm(100)
mn <- min(dat)
mx <- max(dat)
md <- median(dat)


test_that('using data for bounds', {

  expect_equal(
    d_max(dat, low = mn, high = 2),
    d_max(dat, high = 2, use_data = TRUE)
  )
  expect_equal(
    d_max(dat, low = 0, high = mx),
    d_max(dat, low = 0, use_data = TRUE)
  )
  expect_snapshot_error(d_max(dat, high = 2))
  expect_snapshot_error(d_max(dat, low = 2))

  # ----------------------------------------------------------------------------

  expect_equal(
    d_min(dat, low = mn, high = 2),
    d_min(dat, high = 2, use_data = TRUE)
  )
  expect_equal(
    d_min(dat, low = 0, high = mx),
    d_min(dat, low = 0, use_data = TRUE)
  )
  expect_snapshot_error(d_min(dat, high = 2))
  expect_snapshot_error(d_min(dat, low = 2))

  # ----------------------------------------------------------------------------

  expect_equal(
    d_box(dat, low = mn, high = 2),
    d_box(dat, high = 2, use_data = TRUE)
  )
  expect_equal(
    d_box(dat, low = 0, high = mx),
    d_box(dat, low = 0, use_data = TRUE)
  )
  expect_snapshot_error(d_box(dat, high = 2))
  expect_snapshot_error(d_box(dat, low = 2))

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
  expect_snapshot_error(d_target(dat, target = 2, high = 2))
  expect_snapshot_error(d_target(dat, low = 2, high = 2))
  expect_snapshot_error(d_target(dat, low = 2, target = 2))

})


