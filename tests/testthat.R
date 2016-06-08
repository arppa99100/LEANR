library(testthat)
library(LEANR)
library(doMC)
registerDoMC(2)

test_check("LEANR")
