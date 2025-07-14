# bad arguments

    Code
      show_best_desirability(tune::ames_iter_search, maximize(weight_func))
    Condition
      Error in `show_best_desirability()`:
      ! An error occured when computing a desirability score: Error in check_numeric(x, call = call) : `x` should be a numeric vector. .

---

    Code
      show_best_desirability(tune::ames_iter_search)
    Condition
      Error in `desirability()`:
      ! At least one optimization goal (e.g., `maximize()`) should be declared.

---

    Code
      show_best_desirability(tune::ames_iter_search, maximize(potato))
    Condition
      Error in `show_best_desirability()`:
      ! The desirability specification includes 1 variable that was not collected: "potato".

---

    Code
      show_best_desirability(tune::ames_iter_search, embiggen(rsq))
    Condition
      Error:
      ! The following functions are unknown to the desirability2 package: `embiggen()`. Please use one of: `minimize()`, `maximize()`, `constrain()`, `target()`, or `category()`.

