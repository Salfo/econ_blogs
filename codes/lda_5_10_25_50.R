# Run lda
library(topicmodels) # Load the topicmodels package
load("data/constructed_data/blogs_dtm_df.RData") # load the dtm
## 5 topics ###
blogs_lda_5 <- LDA(blogs_dtm_df, # The matrix of words counts
                    k = 5, # The number of topics to construct
                    method = "Gibbs", # Estimation method
                    control = list(iter = 3000, # Number of iterations
                                   burnin = 1000, # Thow out the first 1000 estimates
                                   seed = 324)) # To get a reproducible results
save(x = blogs_lda_5, file = "data/constructed_data/blogs_lda_5.RData")

## 10 topics
blogs_lda_10 <- LDA(blogs_dtm_df, # The matrix of words counts
                    k = 10, # The number of topics to construct
                    method = "Gibbs", # Estimation method
                    control = list(iter = 3000, # Number of iterations
                                   burnin = 1000, # Thow out the first 1000 estimates
                                   seed = 324)) # To get a reproducible results
save(x = blogs_lda_10, file = "data/constructed_data/blogs_lda_10.RData")

## 75 topics
blogs_lda_75 <- LDA(blogs_dtm_df, # The matrix of words counts
                    k = 75, # The number of topics to construct
                    method = "Gibbs", # Estimation method
                    control = list(iter = 3000, # Number of iterations
                                   burnin = 1000, # Thow out the first 1000 estimates
                                   seed = 324)) # To get a reproducible results
save(x = blogs_lda_75, file = "data/constructed_data/blogs_lda_75.RData")

## 50 topics
blogs_lda_50 <- LDA(blogs_dtm_df, # The matrix of words counts
                    k = 50, # The number of topics to construct
                    method = "Gibbs", # Estimation method
                    control = list(iter = 3000, # Number of iterations
                                   burnin = 1000, # Thow out the first 1000 estimates
                                   seed = 324)) # To get a reproducible results
save(x = blogs_lda_50, file = "data/constructed_data/blogs_lda_50.RData")