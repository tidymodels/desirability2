suppressPackageStartupMessages(library(dplyr, quietly = TRUE))

# ------------------------------------------------------------------------------

res <-
  classification_results %>%
  dplyr::mutate(
    d_feat = d_min(num_features, 1, 200),
    d_roc  = d_max(roc_auc, 0.5, 0.9)
  )

# ------------------------------------------------------------------------------

set.seed(1)
dat <- rnorm(100)
mn <- min(dat)
mx <- max(dat)
md <- median(dat)
