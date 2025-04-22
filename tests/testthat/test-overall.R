
test_that('overall desirability computations', {

  expect_equal(
    res |> mutate(d_all  = d_overall(across(starts_with("d_")))) |> purrr::pluck("d_all"),
    sqrt(res$d_feat * res$d_roc)
  )
  expect_equal(
    res |> mutate(d_all  = d_overall(d_feat, d_roc)) |> purrr::pluck("d_all"),
    sqrt(res$d_feat * res$d_roc)
  )
  expect_snapshot(
    res |> dplyr::mutate(d_all  = d_overall(across(everything()))),
    error = TRUE
  )
})
