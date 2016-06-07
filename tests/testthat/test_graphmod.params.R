context("Graph modification parameter behaviour")

# set up test case
data(g2)
data(CCM.pvals)
test.scores<-CCM.pvals$CCM2
test.missing<-test.scores[sample(1:length(test.scores),5500,replace=F)]
test.added<-c(test.scores,seq(1e-8,1e-1,length.out=10))
names(test.added)<-c(names(test.scores),sapply(1:10,function(i)sprintf('Add.gene%i',i)))
test.both<-c(test.missing,seq(1e-8,1e-1,length.out=10))
names(test.both)<-c(names(test.missing),sapply(1:10,function(i)sprintf('Add.gene%i',i)))

test_that('Correct number of local subnetworks returned in missing case', {
      expect_equal( length(run.lean.fromdata(g=g2,gene.list.scores=test.missing,keep.nodes.without.scores=F,n_reps=2)$nhs), length(test.missing))
      expect_lte( length(run.lean.fromdata(g=g2,gene.list.scores=test.missing,keep.nodes.without.scores=T,n_reps=2)$nhs), length(V(g2)))
      expect_gte( length(run.lean.fromdata(g=g2,gene.list.scores=test.missing,keep.nodes.without.scores=T,n_reps=2)$nhs), length(test.missing))
})

test_that('Correct number of local subnetworks returned in added case', {
  expect_equal( length(run.lean.fromdata(g=g2,gene.list.scores=test.added,add.scored.genes=F,n_reps=2)$nhs), length(V(g2)))
  expect_equal( length(run.lean.fromdata(g=g2,gene.list.scores=test.added,add.scored.genes=T,n_reps=2)$nhs), length(test.added))
})

test_that('Correct number of local subnetworks returned in both case', {
  expect_lte( length(run.lean.fromdata(g=g2,gene.list.scores=test.both,keep.nodes.without.scores=F,add.scored.genes=F,n_reps=2)$nhs), length(V(g2)))
  expect_lte( length(run.lean.fromdata(g=g2,gene.list.scores=test.both,keep.nodes.without.scores=F,add.scored.genes=F,n_reps=2)$nhs), length(test.both))
  expect_lte( length(run.lean.fromdata(g=g2,gene.list.scores=test.both,keep.nodes.without.scores=T,add.scored.genes=F,n_reps=2)$nhs), length(V(g2)))
  expect_equal( length(run.lean.fromdata(g=g2,gene.list.scores=test.both,keep.nodes.without.scores=F,add.scored.genes=T,n_reps=2)$nhs), length(test.both))
  expect_gte( length(run.lean.fromdata(g=g2,gene.list.scores=test.both,keep.nodes.without.scores=T,add.scored.genes=T,n_reps=2)$nhs), length(test.both))
  expect_lte( length(run.lean.fromdata(g=g2,gene.list.scores=test.both,keep.nodes.without.scores=T,add.scored.genes=T,n_reps=2)$nhs), length(V(g2))+10)
})