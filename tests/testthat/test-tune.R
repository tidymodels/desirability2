test_that("best results", {
  skip_if_not_installed("tune")

  # fmt: skip
  des_1 <-
    show_best_desirability(
      tune::ames_iter_search,
      n = Inf,
      maximize(rsq),
      minimize(K),
      constrain(lon, low = 1, high = 9),
      target(lat, low = 1, high = 15, target = 5),
      category(
        weight_func,
        categories =
          c(biweight = 0.1, cos = 0,1, epanechnikov = 0.4, gaussian = 0.9,
            inv = 0.0, optimal = 0.7, rank = 0.1, rectangular = 0.0,
            triangular = 1.0, triweight = 0.5)
      )
    ) |>
    dplyr::arrange(.config)

  mtr <- tune::collect_metrics(tune::ames_iter_search, type = "wide") |>
    dplyr::arrange(.config)

  d_rsq_1 <- d_max(mtr$rsq, low = min(mtr$rsq), high = max(mtr$rsq))
  expect_equal(des_1$.d_max_rsq, d_rsq_1)

  d_k_1 <- d_min(mtr$K, use_data = TRUE)
  expect_equal(des_1$.d_min_K, d_k_1)

  d_lon_1 <- d_box(mtr$lon, low = 1, high = 9)
  expect_equal(des_1$.d_box_lon, d_lon_1)

  d_lat_1 <- d_target(mtr$lat, low = 1, high = 15, target = 5)
  expect_equal(des_1$.d_target_lat, d_lat_1)

  d_wt_1 <- d_category(
    mtr$weight_func,
    categories =
      c(biweight = 0.1, cos = 0,1, epanechnikov = 0.4, gaussian = 0.9,
        inv = 0.0, optimal = 0.7, rank = 0.1, rectangular = 0.0,
        triangular = 1.0, triweight = 0.5)
  )
  expect_equal(des_1$.d_category_weight_func, d_wt_1)

  d_all_1 <- d_overall(d_rsq_1, d_k_1, d_lon_1, d_lat_1, d_wt_1)
  expect_equal(des_1$.d_overall, d_all_1)

  expect_equal(nrow(des_1), 20)

  # fmt: skip
  nms_1 <- c("K", "weight_func", "dist_power", "lon", "lat", ".config",
             ".iter", "rmse", "rsq", ".d_max_rsq", ".d_min_K", ".d_box_lon",
             ".d_target_lat", ".d_category_weight_func", ".d_overall")
  expect_named(des_1, nms_1)

  ## No ties
  des_2 <-
    show_best_desirability(
      tune::ames_iter_search,
      n = 3,
      maximize(rsq),
      constrain(lon, low = 1, high = 9)
    )
  expect_equal(nrow(des_2), 3)

  ## selection

  des_3 <-
    select_best_desirability(
      tune::ames_iter_search,
      maximize(rsq),
      constrain(lon, low = 1, high = 9)
    )

  expect_named(
    des_3,
    c("K", "weight_func", "dist_power", "lon", "lat", ".config")
  )

  expect_equal(nrow(des_3), 1)

})

test_that("best results - missing data", {
  skip_if_not_installed("tune")

  na_data <- tune::ames_iter_search
  for (i in 1:nrow(na_data)) {
    tmp <- na_data$.metrics[[i]]
    tmp$.estimate[
      tmp$weight_func == "rank" & tmp$.metric == "rsq"
    ] <- NA

    tmp$.estimate[
      tmp$K == 35L & tmp$.metric == "rmse"
    ] <- NA

    na_data$.metrics[[i]] <- tmp
  }

  # fmt: skip
  des_1 <-
    show_best_desirability(
      na_data,
      n = Inf,
      maximize(rsq),
      minimize(K),
      category(
        weight_func,
        categories =
          c(biweight = 0.1, cos = 0,1, epanechnikov = 0.4, gaussian = 0.9,
            inv = 0.0, optimal = 0.7, rank = 0.1, rectangular = 0.0,
            triangular = 1.0, triweight = 0.5)
      )
    ) |>
    dplyr::arrange(.config)

  expect_equal(is.na(des_1$K), is.na(des_1$.d_min_K))
  expect_equal(is.na(des_1$rsq), is.na(des_1$.d_max_rsq))
  expect_equal(is.na(des_1$weight_func), is.na(des_1$.d_category_weight_func))
  expect_true(!any(is.na(des_1$.d_overall)))

})


test_that("bad arguments", {
  skip_if_not_installed("tune")

  expect_snapshot(
    show_best_desirability(
      tune::ames_iter_search,
      maximize(weight_func)
    ),
    error = TRUE
  )

  expect_snapshot(
    show_best_desirability(tune::ames_iter_search),
    error = TRUE
  )

  expect_snapshot(
    show_best_desirability(
      tune::ames_iter_search,
      maximize(potato)
    ),
    error = TRUE
  )

  expect_snapshot(
    show_best_desirability(
      tune::ames_iter_search,
      embiggen(rsq)
    ),
    error = TRUE
  )
})
