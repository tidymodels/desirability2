# desirability2 (development version)

* Export a helper function (`make_desirability_cols()`) to make it easier for 
  other packages to import and use desirability2. 
  
* The `.use_data` default for `desirability()` was changed to `TRUE`. 

* When `.use_data = TRUE`, infinite values are ignored when computing limits. 

# desirability2 0.1.0

* Transition from the magrittr pipe to the base R pipe.

* Added a developer oriented function, `desirability()`, that can be used as a 
  user-facing API for methods. 

* Two new functions to support the tune package were added. 
  `select_best_desirability()` and `show_best_desirability()` can be used for 
  multiparameter optimization of tuning parameters.  

# desirability2 0.0.1

* Added a `NEWS.md` file to track changes to the package.
