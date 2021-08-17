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
