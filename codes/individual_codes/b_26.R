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

i_url <- 'https://pro.creditwritedowns.com'
ii_urls <- vector()
#ii_urls[1] <- i_url
for (i in 1:1005) {
  ii_urls[i] <- paste0(i_url, '/page/', i, "#.WuVKJ8gvwVB")
}

#url = 'https://baselinescenario.com'
b_26 <- data.frame(data = character(),
                   Links = character())
for (url in ii_urls) {
  l_xpath = '//*[(@id = "at4-wncc")] | //*[(@id = "content")]//*[contains(concat( " ", @class, " " ), concat( " ", "post-title", " " ))]//../a'
  d_xpath = '//*[(@id = "at4-wncc")] | //*[contains(concat( " ", @class, " " ), concat( " ", "updated", " " ))]'
  bb <- extract_links(url = url,
                        l_xpath = l_xpath,
                        d_xpath = d_xpath)
  bb <- data.frame(date = bb$date[-1], Links = bb$links, stringsAsFactors = FALSE)
  b_26 <- rbind(b_26, bb)
  Sys.sleep(2) # slows down the files request.
}



#b_26 <- data.frame(date = b_26$date, Links = b_26$links, stringsAsFactors = FALSE)

dd <- str_split_fixed(b_26$date, pattern = ', ', n = 2)
#dd1 <- paste0(dd[, 1], ", ", str_sub(dd[, 2], start = 1L, end = 4L))

#dd <- str_trim(dd)
#dd1 <- str_split_fixed(dd, pattern = ' ', n = 2)

b_26$date <- dd

# A function to scrape the texts
sp_number = 0
missing <- NULL
for (url in b_26$Links) {
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
    path <- paste0('data/blog_texts/', "b_26_", sp_number, "-", 
                   b_26$date[sp_number], ".txt")
    fileConn<-file(path)
    writeLines(text, fileConn)
    close(fileConn)
  Sys.sleep(2) # slows down the files request. 
}
