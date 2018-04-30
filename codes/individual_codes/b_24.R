library(rvest)
library(tidyverse)
# A function to extract the web links

extract_links <- function(url, l_xpath = NULL, d_xpath = NULL){
  blog_web <- read_html(url)
  xp <- l_xpath #paste0(l_xpath, '/..//a')
  links <- blog_web %>%
    html_nodes(xpath = xp) %>%
    html_attr('href')
  date <- blog_web %>%
    html_nodes(xpath = d_xpath) %>%
    html_text()
  log_infos <- list(date = date, links = links)
  return(log_infos)
}

i_url <- 'https://baselinescenario.com'
ii_urls <- vector()
ii_urls[1] <- i_url
for (i in 1:290) {
  ii_urls[(i+1)] <- paste0(i_url, '/page/', i, '/')
}

#url = 'https://baselinescenario.com'
b_24 <- data.frame(data = character(),
                   Links = character())
for (url in ii_urls) {
  l_xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "entry-title", " " ))]//a'
  d_xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "entry-date", " " ))]'
  bb <- extract_links(url = url,
                        l_xpath = l_xpath,
                        d_xpath = d_xpath)
  bb <- data.frame(date = bb$date, Links = bb$links, stringsAsFactors = FALSE)
  b_24 <- rbind(b_24, bb)
}
#l_xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "entry-title", " " ))]//a'
#d_xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "entry-date", " " ))]'
#b_24 <- extract_links(url = url,
#                         l_xpath = l_xpath,
#                         d_xpath = d_xpath)

#b_24 <- data.frame(date = b_24$date, Links = b_24$links, stringsAsFactors = FALSE)

dd <- str_split_fixed(b_24$date, pattern = 'at', n = 2)[, 1]
dd <- str_trim(dd)

b_24$date <- dd

# A function to scrape the texts
sp_number = 0
missing <- NULL
for (url in b_24$Links) {
  sp_number = sp_number + 1
    # scrape text from html files
    text <- tryCatch(read_html(url), # to prevent errors from crashing the loop
                     error = function(e) e)
    if(inherits(text, "error")){
      missing <- c(missing, sp_number) 
      next
    }
    text <- text %>% 
      html_nodes(xpath = '//p') %>%
      html_text()
    path <- paste0('data/blog_texts/', "b_24_", sp_number, "-", 
                   b_24$date[sp_number], ".txt")
    fileConn<-file(path)
    writeLines(text, fileConn)
    close(fileConn)
  Sys.sleep(2) # slows down the files request. 
}
