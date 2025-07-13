# basic desirability functions

    Code
      d1@inputs
    Output
      [[1]]
      maximize(a)
      
      [[2]]
      minimize(b, scale = 2)
      
      [[3]]
      constrain(x, low = 1, high = 2)
      

---

    Code
      d1@translated
    Output
      [[1]]
      d_max(a)
      
      [[2]]
      d_min(b, scale = 2)
      
      [[3]]
      d_box(x, low = 1, high = 2)
      

---

    Code
      d1@variables
    Output
      [[1]]
      [1] "a"
      
      [[2]]
      [1] "b"
      
      [[3]]
      [1] "x"
      

---

    Code
      d1
    Message
      
      -- Simultaneous Optimization via Desirability Functions ------------------------
      
      3 desirability functions for 3 variables
      Variables: "a", "b", and "x".

---

    Code
      d2@inputs
    Output
      [[1]]
      target(a, low = 1, target = 2, high = 3, scale_low = 2)
      
      [[2]]
      category(b, categories = list(a = 0.1, b = 0.2, c = 0.3))
      
      [[3]]
      constrain(x, low = 1, high = 2)
      

---

    Code
      d2@translated
    Output
      [[1]]
      d_target(a, low = 1, target = 2, high = 3, scale_low = 2, use_data = TRUE)
      
      [[2]]
      d_category(b, categories = list(a = 0.1, b = 0.2, c = 0.3), use_data = TRUE)
      
      [[3]]
      d_box(x, low = 1, high = 2, use_data = TRUE)
      

---

    Code
      d2@variables
    Output
      [[1]]
      [1] "a"
      
      [[2]]
      [1] "b"
      
      [[3]]
      [1] "x"
      

---

    Code
      d2
    Message
      
      -- Simultaneous Optimization via Desirability Functions ------------------------
      
      3 desirability functions for 3 variables
      Variables: "a", "b", and "x".

# bad desirability inputs

    Code
      desirability()
    Condition
      Error in `desirability()`:
      ! At least one optimization goal (e.g., `maximize()`) should be declared.

---

    Code
      desirability(1)
    Condition
      Error:
      ! There needs to be at least one argument to the optimization goal functions.

---

    Code
      desirability(maximize(happiness), 1)
    Condition
      Error:
      ! There needs to be at least one argument to the optimization goal functions.

---

    Code
      desirability(monitize(synergies))
    Condition
      Error:
      ! The following functions are unknown to the desirability2 package: `monitize()`. Please use one of: `minimize()`, `maximize()`, `constrain()`, `target()`, or `category()`.

---

    Code
      desirability(maximize(happiness, 1))
    Condition
      Error:
      ! 1 optimization goal has additional arguments that are not named. All but the first argument should be named.

---

    Code
      desirability(maximize(argument = happiness))
    Condition
      Error:
      ! 1 optimization goal has a first argument that is named. It should be unnamed.

---

    Code
      desirability(maximize(happiness, 1), )
    Condition
      Error:
      ! 1 optimization goal has additional arguments that are not named. All but the first argument should be named.

