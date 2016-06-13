library(testthat)
library(LEANR)
# try to load parallel backend to speed up background dist calculations
if (require('doMC')) {
  registerDoMC(2)
} else {
  warning('Could not find package doMC. Trying package doParallel as an alternative...')
  if (require('doParallel')){
    registerDoParallel(cores=2)
  } else {
    warning('Neither library doMC nor doParallel could be found. Parallel execution disabled.')
  }
}

test_check("LEANR")
