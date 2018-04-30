library(tm)
library(tidyverse)
MyDocuments <- DirSource("data/blog_texts/") #path for documents
MyCorpus <- Corpus(MyDocuments, readerControl=list(reader=readPlain)) #load in documents

f <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
MyCorpus <- tm_map(MyCorpus, f, "[^[:alnum:]]") # Remove anything that is not alphanumeric
MyCorpus <- tm_map(MyCorpus, content_transformer(tolower))
MyCorpus <- tm_map(MyCorpus, removeWords, stopwords('english'))
MyCorpus <- tm_map(MyCorpus, stripWhitespace)
MyCorpus <- tm_map(MyCorpus, removePunctuation)
MyCorpus <- tm_map(MyCorpus, removeNumbers)


dtm <- DocumentTermMatrix(MyCorpus,
                          control = list(wordLengths = c(4, Inf), stemming = TRUE))
blogs_dtm <- dtm %>% removeSparseTerms(sparse=0.95) # Drop words that are present in less than 25% of the documents
#dim(Sp_dtm) # inspect the dimension of the data set
blogs_dtm_df <- as.data.frame(as.matrix(blogs_dtm)) # Convert table into a dataframe for ease of data manipulation
row_sums <- rowSums(blogs_dtm_df)
blogs_dtm_df$row_sums <- row_sums

blogs_dtm_df <- blogs_dtm_df %>%
  subset(row_sums > 100) # to remove empty (or very short) documents
blogs_dtm_df$row_sums = NULL

save(x = blogs_dtm_df, file = "data/constructed_data/blogs_dtm_df.RData")
