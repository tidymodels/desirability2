library(desirability)

x <- seq(0, 1, length.out = 11)

# ------------------------------------------------------------------------------

dput(predict(dMax(.1, .9), x))

dput(predict(dMax(0, 1), x))

dput(round(predict(dMax(.1, .9, 1/2), x), 4))

dput(round(predict(dMax(.1, .9, 3), x), 4))

# ------------------------------------------------------------------------------

dput(predict(dMin(.1, .9), x))

dput(predict(dMin(0, 1), x))

dput(round(predict(dMin(.1, .9, 1/2), x), 4))

dput(round(predict(dMin(.1, .9, 3), x), 4))

# ------------------------------------------------------------------------------

dput(round(predict(dTarget(.1, .3, .9), x), 4))

dput(round(predict(dTarget(.1, .3, .9, 1/2, 3), x), 4))

# ------------------------------------------------------------------------------

x_points <- (1:5)/5
d_points <- c(0.36, 0.64, 0.84, 0.96, 1)
# different from d_custom
# dput(round(predict(dArb(x_points, d_points), x), 4))
