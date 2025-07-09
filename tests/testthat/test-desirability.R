test_that("basic desirability functions", {
  d1 <-
    desirability(
      maximize(a),
      minimize(b, scale = 2),
      constrain(x, low = 1, high = 2)
    )
  expect_snapshot(
    d1@inputs
  )
  expect_snapshot(
    d1@translated
  )
  expect_snapshot(
    d1@variables
  )
  expect_snapshot(
    d1
  )

  d2 <-
    desirability(
      target(a, low = 1, target = 2, high = 3, scale_low = 2),
      category(b, list(a = 0.1, b = 0.2, c = 0.3)),
      constrain(x, low = 1, high = 2),
      .use_data = TRUE
    )
  expect_snapshot(
    d2@inputs
  )
  expect_snapshot(
    d2@translated
  )
  expect_snapshot(
    d2@variables
  )
  expect_snapshot(
    d2
  )

})

test_that("bad desirability inputs", {

  expect_snapshot(desirability(), error = TRUE)
  expect_snapshot(desirability(1), error = TRUE)
  expect_snapshot(desirability(maximize(happiness), 1), error = TRUE)
  expect_snapshot(desirability(monitize(synergies)), error = TRUE)

})
