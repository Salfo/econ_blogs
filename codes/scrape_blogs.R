library(rvest)
library(tidyverse)
library(readxl)
blogs_list <- read_excel("data/blogs_list.xlsx")
blogs_list$ID <- paste0("b_", 1:200)
blogs_list <- blogs_list %>%
  filter(Links1 != "NA")
b_1  <- "https://www.nytimes.com/column/paul-krugman"
w_b1 <- read_html(b_1)
