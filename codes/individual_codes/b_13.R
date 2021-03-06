# A function to extract the web links

extract_links <- function(url, l_xpath = NULL, d_xpath = NULL){
  blog_web <- read_html(url)
  xp <- paste0(l_xpath, '/..//a')
  links <- blog_web %>%
    html_nodes(xpath = xp) %>%
    html_attr('href')
  date <- blog_web %>%
    html_nodes(xpath = d_xpath) %>%
    html_text()
  log_infos <- list(date = date, links = links)
  return(log_infos)
}

url = 'http://www.calculatedriskblog.com/'
l_xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "entry-title", " " ))]//a'
d_xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "entry-content", " " ))]//*[contains(concat( " ", @class, " " ), concat( " ", "fn", " " ))]'
b_13 <- extract_links(url = url,
                         l_xpath = l_xpath,
                         d_xpath = d_xpath)

b_13 <- data.frame(date = b_13$date, Links = b_13$links)
dd <- str_split_fixed(b_13$date, pattern = "on", n = 2)
dd <- str_split_fixed(dd[,2], pattern = "2018", n = 2)
dd <- paste0(dd[, 1], 2018)
dd <- str_replace_all(dd, pattern = '/', replacement = ' ')
dd <- str_trim(dd)

b_13 <- data.frame(date = dd, 
                   Links = b_13$Links)

# A function to scrape the texts
sp_number = 0
missing <- NULL
for (url in b_13$Links) {
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
    path <- paste0('data/blog_texts/', "b_13_", sp_number, 
                   b_13$date[sp_number], ".txt")
    fileConn<-file(path)
    writeLines(text, fileConn)
    close(fileConn)
  Sys.sleep(2) # slows down the files request. 
}
