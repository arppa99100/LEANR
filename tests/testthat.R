library(testthat)
library(LEANR)
library(doMC)
registerDoMC(3)

test_check("LEANR")
