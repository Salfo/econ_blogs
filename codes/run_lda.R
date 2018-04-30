# Run lda
library(topicmodels) # Load the topicmodels package
load("data/constructed_data/blogs_dtm_df.RData") # load the dtm
blogs_lda_25 <- LDA(blogs_dtm_df, # The matrix of words counts
                   k = 25, # The number of topics to construct
                   method = "Gibbs", # Estimation method
                   control = list(iter = 3000, # Number of iterations
                                  burnin = 1000, # Thow out the first 1000 estimates
                                  seed = 324)) # To get a reproducible results
save(x = blogs_lda_25, file = "data/constructed_data/blogs_lda_25.RData")

###
blogs_lda_50 <- LDA(blogs_dtm_df, # The matrix of words counts
                    k = 50, # The number of topics to construct
                    method = "Gibbs", # Estimation method
                    control = list(iter = 3000, # Number of iterations
                                   burnin = 1000, # Thow out the first 1000 estimates
                                   seed = 324)) # To get a reproducible results
save(x = blogs_lda_50, file = "data/constructed_data/blogs_lda_50.RData")

###
blogs_lda_75 <- LDA(blogs_dtm_df, # The matrix of words counts
                    k = 75, # The number of topics to construct
                    method = "Gibbs", # Estimation method
                    control = list(iter = 3000, # Number of iterations
                                   burnin = 1000, # Thow out the first 1000 estimates
                                   seed = 324)) # To get a reproducible results
save(x = blogs_lda_75, file = "data/constructed_data/blogs_lda_75.RData")

###
blogs_lda_100 <- LDA(blogs_dtm_df, # The matrix of words counts
                    k = 100, # The number of topics to construct
                    method = "Gibbs", # Estimation method
                    control = list(iter = 3000, # Number of iterations
                                   burnin = 1000, # Thow out the first 1000 estimates
                                   seed = 324)) # To get a reproducible results
save(x = blogs_lda_100, file = "data/constructed_data/blogs_lda_100.RData")
