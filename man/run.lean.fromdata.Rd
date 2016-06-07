\name{run.lean.fromdata}
\alias{lean.fromdata}
\alias{run.lean.fromdata}
\title{
 Run the LEAN approach using a graph and p-value list as input
}
\description{
 Apply the LEAN approach to a network given as an igraph object <g> and a list of measured pvalues <gene.list.scores>
}
\usage{
run.lean.fromdata(gene.list.scores, g,
					ranked = F, add.scored.genes = F,
					keep.nodes.without.scores = F, verbose = F, 
					n_reps = 10000, bootstrap = F)
}
\arguments{
  \item{gene.list.scores}{
  gene p-values encoded as a numeric vector named with protein/gene ids (have to match node names of the graph given in <g>)
}
  \item{g}{
  igraph graph representing a network containing only nodes for which a score in gene.list.scores is defined
}
  \item{ranked}{
  whether to transform input p-values into a uniformly distributed list of p-values based on the genes' rank before LEAN p-value calculation
}
  \item{add.scored.genes}{
  whether to create one singleton node for each gene with a score but not occurring in the graph
}
  \item{keep.nodes.without.scores}{
  whether to keep nodes of the graph that have no recorded score. For those nodes it is still possible to compute enrichment scores if at least one of their network neighbors has a recorded score.
}
  \item{verbose}{
  whether to print additional status messages
}
  \item{n_reps}{
  the number of samples each background distribution should consist of. Largely influences the run-time, but higher values needed for meaningful empirical pvalues !
}
  \item{bootstrap}{
  whether to draw the pvalues of the background distributions with or without replacement
}
}
\value{
A list object containing the results of the LEAN run. The list encompasses the following elements:
\item{restab }{Result table of applying LEAN to the real data}
\item{randtab }{Result table of applying LEAN to a permuted p-value list}
\item{indGraph }{igraph graph representing the information in the input graph <g> after adapting it according to parameters <add.scored.genes>, <keep.nodes.without.scores> and the presence of gene scores in <gene.list.scores>}
\item{nhs }{The extracted local subnetworks (neighborhoods). Encoded as a named (by protein/gene ids) list of igraph node indices detailing each evaluated local subnetwork}
\item{gene.scores }{The gene p-values extracted from <gene.list.scores>. Encoded as a numeric vector named with gene ids}
}
\references{
Gwinner et al., Network-based analysis of omics data: The LEAN method, MS submitted to Bioinformatics
}
\author{
Frederik Gwinner
}
\seealso{
    \code{\link[LEANR:run.lean]{run.lean}}
    \code{\link[LEANR:LEANR-package]{LEANR-package}}
}
\examples{
## Simple use case
## Run LEAN method from a given graph and gene p-value list
\dontrun{
# load a precompiled graph <g2> ...
data(g2)
# ... and gene p-values <gene.list.scores> from package LEANR
data(gene.list.scores)
# compute LEAN p-values
res<-run.lean.fromdata(g2,gene.list.scores,verbose=T)

# extract significant genes
p.cut <- 0.05
sig_genes<-rownames(res$restab[res$restab[,'PLEAN'] < p.cut & 
							   !is.na(res$restab[,'PLEAN']),])
sig_genes_rand<-rownames(res$randtab[res$randtab[,'PLEAN'] < p.cut & 
							   !is.na(res$randtab[,'PLEAN']),])
print(sprintf("Found \%i significant gene neighborhoods at pLEAN < \%g",
              length(sig_genes),p.cut))
print(sprintf("Found \%i significant gene neighborhoods in permuted data at pLEAN < \%g",
			  length(sig_genes_rand),p.cut))

# write list of significant gene ids to file 
# (can be used to select those genes from the full network in Cytoscape)
write.table(sig_genes,"./sig_genes_p0.05.nids",sep='\t',quote=F,row.names=F,col.names=F)
# write significant results to table
write.table(res$restab[sig_genes,],"./sig_plean_table_p0.05.txt",sep='\t',quote=F)

# create sif files depicting the local subnetworks for all significant hits 
# detected by the LEAN method
for (prot_id in sig_genes){
    write.ls.to.sif(prot_id,
    			 res$restab, res$indGraph, res$nhs, res$gene.scores,
    			 sprintf("./substar_\%s.sif",prot_id)
    )
}
}
}
