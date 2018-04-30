library(topicmodels)
library(tm)
library(tidyverse)
options(digits = 3)
load('data/constructed_data/blogs_lda_5.RData')
# theta matrix
K = 5
theta_matrix <- posterior(blogs_lda_5)$topics # Extract the theta matrix
theta_matrix <- round(as.data.frame(theta_matrix), digits = 3)
names(theta_matrix) <- paste0("Topic.", 1:K) # Name the columns
#head(theta_matrix, n = 10) # Print out the first 10 observations
# phi matrix
phi_matrix <- posterior(blogs_lda_5)$terms # Extract the phi matrix
phi_matrix <- round(phi_matrix, 3) # Round the numbers to 3 decimals
phi_matrix[, 1:20] # Print out the first 20 words
T_phi_matrix <- as.data.frame(t(phi_matrix))
names(T_phi_matrix) <- paste0("Topic.", 1:K)
#T_phi_matrix[1:20, ] # Print out the first 20 words
# topic terms
terms_matrix <- terms(blogs_lda_5, 30) # Extract the first 30 most important words for each topic
#terms_matrix[1:15, ] # Print out the first 15 words

# Cluster analysis

# Take a random sample of theta
set.seed(314)
n_s <- sample(x = 1:nrow(theta_matrix),
              size = 100)
sub_theta <- theta_matrix[n_s, ]

# distance matrix 
dist_m = dist(sub_theta)

# hierarchical clustering analysis
clus_blogs = hclust(dist_m, method = "ward.D")

# plot dendrogram
plot(clus_blogs, hang = -1)

library(ape)
# convert 'hclust' to 'phylo' object
phylo_tree = as.phylo(clus_blogs)

# get edges
graph_edges = phylo_tree$edge

library(igraph)

# get graph from edge list
graph_net = graph.edgelist(graph_edges)

# plot graph
plot(graph_net)

##
# extract layout (x-y coords)
graph_layout = layout.auto(graph_net)

# number of observations
nobs = nrow(sub_theta)

# start plot
plot(graph_layout[,1], graph_layout[,2], type = "n", axes = FALSE,
     xlab = "", ylab = "")
# draw tree branches
segments(
  x0 = graph_layout[graph_edges[,1],1], 
  y0 = graph_layout[graph_edges[,1],2],
  x1 = graph_layout[graph_edges[,2],1],
  y1 = graph_layout[graph_edges[,2],2],
  col = "#dcdcdc55", lwd = 3.5
)
# add labels
text(graph_layout[1:nobs,1], graph_layout[1:nobs,2],
     phylo_tree$tip.label, cex = 1, xpd = TRUE, font = 1)

ranK_row <- function(x, n_top){
  threshold = sort(x, decreasing = TRUE)[n_top]
  return(threshold)
}
  
n_top_by_doc <- function(theta, n_top = 3){
  thresholds <- apply(theta, MARGIN = 1, FUN = ranK_row, n_top = n_top)
  thresholds <- data.frame(thresholds = thresholds)
  new_theta <- theta*(theta >= thresholds$thresholds)
}

sub_theta <- n_top_by_doc(theta = sub_theta, n_top = 1)

