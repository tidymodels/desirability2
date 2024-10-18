# overall desirability computations

    Code
      res %>% dplyr::mutate(d_all = d_overall(across(everything())))
    Condition
      Error in `dplyr::mutate()`:
      i In argument: `d_all = d_overall(across(everything()))`.
      Caused by error in `d_overall()`:
      ! 1 column is not within `[0, 1]`: "num_features"

