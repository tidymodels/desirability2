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
      Error in `d_min()`:
      ! The values should be `low < high` (actual are 0 and -1).

---

    Code
      d_min(x, 0:1, 2)
    Condition
      Error in `d_min()`:
      ! `low` must be a number, not an integer vector.

---

    Code
      d_min(x, 0, 1:2)
    Condition
      Error in `d_min()`:
      ! `high` must be a number, not an integer vector.

---

    Code
      d_min(x, NA_real_, 1:2)
    Condition
      Error in `d_min()`:
      ! `low` must be a number, not a numeric `NA`.

---

    Code
      d_min(x, 0, NA_real_)
    Condition
      Error in `d_min()`:
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
      Error in `d_target()`:
      ! `low` must be a number, not an integer vector.

---

    Code
      d_target(x, 0, 1:2, 3)
    Condition
      Error in `d_target()`:
      ! `target` must be a number or `NULL`, not an integer vector.

---

    Code
      d_target(x, 0, 1, 2:3)
    Condition
      Error in `d_target()`:
      ! `high` must be a number, not an integer vector.

---

    Code
      d_target(x, NA_real_, 1, 2)
    Condition
      Error in `d_target()`:
      ! `low` must be a number, not a numeric `NA`.

---

    Code
      d_target(x, 0, NA_real_, 1)
    Condition
      Error in `d_target()`:
      ! `target` must be a number or `NULL`, not a numeric `NA`.

---

    Code
      d_target(x, 0, 1, NA_real_)
    Condition
      Error in `d_target()`:
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
      Error in `d_custom()`:
      ! `values` (4) and `d` (5) should be the same length.

---

    Code
      d_custom(x, x_points, d_points[-1])
    Condition
      Error in `d_custom()`:
      ! `values` (5) and `d` (4) should be the same length.

---

    Code
      d_custom(x, letters, d_points)
    Condition
      Error in `d_custom()`:
      ! `values` should be a numeric vector.

---

    Code
      d_custom(x, x_points, letters)
    Condition
      Error in `d_custom()`:
      ! Desirability values should be numeric and complete in the range [0, 1].

---

    Code
      d_box(x, 0, -1)
    Condition
      Error in `d_box()`:
      ! The values should be `low < high` (actual are 0 and -1).

---

    Code
      d_box(x, 0:1, 2)
    Condition
      Error in `d_box()`:
      ! `low` must be a number, not an integer vector.

---

    Code
      d_box(x, 0, 1:2)
    Condition
      Error in `d_box()`:
      ! `high` must be a number, not an integer vector.

---

    Code
      d_box(x, NA_real_, 1:2)
    Condition
      Error in `d_box()`:
      ! `low` must be a number, not a numeric `NA`.

---

    Code
      d_box(x, 0, NA_real_)
    Condition
      Error in `d_box()`:
      ! `high` must be a number, not a numeric `NA`.

---

    Code
      d_category(month.abb[2:4], oob)
    Condition
      Error in `d_category()`:
      ! Desirability values should be numeric and complete in the range [0, 1].

---

    Code
      d_min(letters, 1, 2)
    Condition
      Error in `check_numeric()`:
      ! `x` should be a numeric vector.

---

    Code
      d_min(letters[1], 1, 2)
    Condition
      Error in `check_numeric()`:
      ! `x` should be a numeric vector.

