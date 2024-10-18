# correct values

    Code
      d_max(x, 0, -1)
    Condition
      Error in `d_max()`:
      ! The values should be `low < high` (actual are 0 and -1).

---

    Code
      d_max(x, 0:1, 2)
    Condition
      Error in `d_max()`:
      ! `low` must be a number, not an integer vector.

---

    Code
      d_max(x, 0, 1:2)
    Condition
      Error in `d_max()`:
      ! `high` must be a number, not an integer vector.

---

    Code
      d_max(x, NA_real_, 1:2)
    Condition
      Error in `d_max()`:
      ! `low` must be a number, not a numeric `NA`.

---

    Code
      d_max(x, 0, NA_real_)
    Condition
      Error in `d_max()`:
      ! `high` must be a number, not a numeric `NA`.

---

    Code
      d_max(x, 0, 1, scale = -1)
    Condition
      Error in `d_max()`:
      ! `scale` must be a number larger than or equal to 0, not the number -1.

---

    Code
      d_max(x, 0, 1, scale = 1:2)
    Condition
      Error in `d_max()`:
      ! `scale` must be a number, not an integer vector.

---

    Code
      d_max(x, 0, 1, scale = NA)
    Condition
      Error in `d_max()`:
      ! `scale` must be a number, not `NA`.

---

    Code
      d_min(x, 0, -1)
    Condition
      Error in `check_value_order()`:
      ! The values should be `low < high` (actual are 0 and -1).

---

    Code
      d_min(x, 0:1, 2)
    Condition
      Error in `stop_input_type()`:
      ! `low` must be a number, not an integer vector.

---

    Code
      d_min(x, 0, 1:2)
    Condition
      Error in `stop_input_type()`:
      ! `high` must be a number, not an integer vector.

---

    Code
      d_min(x, NA_real_, 1:2)
    Condition
      Error in `stop_input_type()`:
      ! `low` must be a number, not a numeric `NA`.

---

    Code
      d_min(x, 0, NA_real_)
    Condition
      Error in `stop_input_type()`:
      ! `high` must be a number, not a numeric `NA`.

---

    Code
      d_min(x, 0.1, 0.9, scale = -1)
    Condition
      Error in `d_min()`:
      ! `scale` must be a number larger than or equal to 0, not the number -1.

---

    Code
      d_min(x, 0.1, 0.9, scale = 1:2)
    Condition
      Error in `d_min()`:
      ! `scale` must be a number, not an integer vector.

---

    Code
      d_min(x, 0.1, 0.9, scale = NA)
    Condition
      Error in `d_min()`:
      ! `scale` must be a number, not `NA`.

---

    Code
      d_target(x, 0:1, 2, 3)
    Condition
      Error in `stop_input_type()`:
      ! `low` must be a number, not an integer vector.

---

    Code
      d_target(x, 0, 1:2, 3)
    Condition
      Error in `stop_input_type()`:
      ! `target` must be a number or `NULL`, not an integer vector.

---

    Code
      d_target(x, 0, 1, 2:3)
    Condition
      Error in `stop_input_type()`:
      ! `high` must be a number, not an integer vector.

---

    Code
      d_target(x, NA_real_, 1, 2)
    Condition
      Error in `stop_input_type()`:
      ! `low` must be a number, not a numeric `NA`.

---

    Code
      d_target(x, 0, NA_real_, 1)
    Condition
      Error in `stop_input_type()`:
      ! `target` must be a number or `NULL`, not a numeric `NA`.

---

    Code
      d_target(x, 0, 1, NA_real_)
    Condition
      Error in `stop_input_type()`:
      ! `high` must be a number, not a numeric `NA`.

---

    Code
      d_target(x, 0.1, 0.3, 0.9, scale_low = -1)
    Condition
      Error in `d_target()`:
      ! `scale_low` must be a number larger than or equal to 0, not the number -1.

---

    Code
      d_target(x, 0.1, 0.3, 0.9, scale_low = 1:2)
    Condition
      Error in `d_target()`:
      ! `scale_low` must be a number, not an integer vector.

---

    Code
      d_target(x, 0.1, 0.3, 0.9, scale_low = NA)
    Condition
      Error in `d_target()`:
      ! `scale_low` must be a number, not `NA`.

---

    Code
      d_target(x, 0.1, 0.3, 0.9, scale_high = -1)
    Condition
      Error in `d_target()`:
      ! `scale_high` must be a number larger than or equal to 0, not the number -1.

---

    Code
      d_target(x, 0.1, 0.3, 0.9, scale_high = 1:2)
    Condition
      Error in `d_target()`:
      ! `scale_high` must be a number, not an integer vector.

---

    Code
      d_target(x, 0.1, 0.3, 0.9, scale_high = NA)
    Condition
      Error in `d_target()`:
      ! `scale_high` must be a number, not `NA`.

---

    Code
      d_custom(x, x_points[-1], d_points)
    Condition
      Error in `is_vector_args()`:
      ! '`values`' and '`d`' should be the same length.

---

    Code
      d_custom(x, x_points, d_points[-1])
    Condition
      Error in `is_vector_args()`:
      ! '`values`' and '`d`' should be the same length.

---

    Code
      d_custom(x, letters, d_points)
    Condition
      Error in `is_vector_args()`:
      ! `values` should be a numeric vector.

---

    Code
      d_custom(x, x_points, letters)
    Condition
      Error in `post_process_plurals()`:
      ! Cannot pluralize without a quantity

---

    Code
      d_box(x, 0, -1)
    Condition
      Error in `check_value_order()`:
      ! The values should be `low < high` (actual are 0 and -1).

---

    Code
      d_box(x, 0:1, 2)
    Condition
      Error in `stop_input_type()`:
      ! `low` must be a number, not an integer vector.

---

    Code
      d_box(x, 0, 1:2)
    Condition
      Error in `stop_input_type()`:
      ! `high` must be a number, not an integer vector.

---

    Code
      d_box(x, NA_real_, 1:2)
    Condition
      Error in `stop_input_type()`:
      ! `low` must be a number, not a numeric `NA`.

---

    Code
      d_box(x, 0, NA_real_)
    Condition
      Error in `stop_input_type()`:
      ! `high` must be a number, not a numeric `NA`.

---

    Code
      res %>% mutate(d_all = d_overall(across(everything())))
    Condition
      Error in `mutate()`:
      i In argument: `d_all = d_overall(across(everything()))`.
      Caused by error in `purrr::map()`:
      i In index: 6.
      i With name: num_features.
      Caused by error in `post_process_plurals()`:
      ! Cannot pluralize without a quantity

