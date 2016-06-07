\name{run.lean}
\alias{lean}
\alias{run.lean}
\title{
 Run the LEAN approach
}
\description{
 Apply the LEAN approach to a given network in sif format from file <net_file> and a list of pvalues from <rank_file>
}
\usage{
run.lean(rank_file, net_file, ranked = F, 
    add.scored.genes = F, keep.nodes.without.scores = F, 
    verbose = F, n_reps = 10000, bootstrap = F)
}
\arguments{
  \item{rank_file}{
  file containing gene p-values
}
  \item{net_file}{
  file containing network in sif format
}
  \item{ranked}{
  whether to transform input p-values into a uniformly distributed list of p-values based on the genes' rank before p* calculation
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
\item{indGraph }{igraph graph representing the information in the sif file after adapting it according to parameters <add.scored.genes>, <keep.nodes.without.scores> and the presence of gene scores in the pvalue file}
\item{nhs }{The extracted local subnetworks. Encoded as a named (by protein/gene ids) list of igraph node indices detailing each evaluated local subnetwork}
\item{gene.scores }{The gene p-values extracted from the input file. Encoded as a numeric vector named with protein/gene ids}
}
\references{
Gwinner et al., Network-based analysis of omics data: The LEAN method, MS submitted to Bioinformatics
}
\author{
Frederik Gwinner
}
\seealso{
    \code{\link[LEANR:run.lean.fromdata]{run.lean.fromdata}}
    \code{\link[LEANR:LEANR-package]{LEANR-package}}
}
\examples{
## Simple use case starting from a network and p-value file
## contained in the LEANR package install directory
\dontrun{ 
# compute LEAN p-values starting from a network file and a p-value file
rank_file<-system.file('input_pvals_CCM2.txt')
net_file<-system.file('STRING_Mouse_fs900.sif')
res<-run.lean(rank_file,net_file,verbose=T)

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

# write list of significant gene ids to file (can be used to select those genes in Cytoscape)
write.table(sig_genes,"./sig_genes_p0.05.nids",sep='\t',quote=F,row.names=F,col.names=F)
# write significant results to table
write.table(res$restab[sig_genes,],"./sig_plean_table_p0.05.txt",sep='\t',quote=F)

# create sif files depicting the local subnetworks for the first 10 significant hits 
# detected by the LEAN method
for (prot_id in sig_genes[1:10]){
    write.ls.to.sif(prot_id,res,sprintf("./substar_\%s.sif",prot_id))
}

# Display the genes in the local subnetwork around a significant hit in tabular format
get.ls.info(sig_genes[1],res)
}
}
