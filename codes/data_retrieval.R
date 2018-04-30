# Get the list of blogs
library(rvest)
library(dplyr)
blog_urls <- "http://www.onalytica.com/blog/posts/top-200-most-influential-economics-blogs/"
blogs_webpage <- read_html(blog_urls)
blogs_tabl <- blogs_webpage %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table(header = 1)
blogs_tabl = blogs_tabl[, -1]
#write.csv(x = blogs_tabl, file = "data/blogs_list.csv", row.names = FALSE)
