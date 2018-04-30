# A function to extract the web links

extract_links <- function(url, l_xpath = NULL, d_xpath = NULL){
  blog_web <- read_html(url)
  xp <- paste0(l_xpath, '//..//a')
  links <- blog_web %>%
    html_nodes(xpath = xp) %>%
    html_attr('href')
  date <- blog_web %>%
    html_nodes(xpath = d_xpath) %>%
    html_text()
  log_infos <- list(date = date, links = links)
  return(log_infos)
}

url = 'https://www.nytimes.com/column/paul-krugman'
b_1 <- extract_links(url = url,
                         l_xpath = '//*[(@id = \"latest-panel\")]',
                         d_xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "dateline", " " ))]')
Links <- unlist(b_1$links)[-c(1,2, 23, 44)]
b_1 <- data.frame(date = b_1$date, Links = Links)

# A function to scrape the texts
sp_number = 0
missing <- NULL
for (url in b_1$Links) {
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
    path <- paste0('data/blog_texts/', "b_1_", sp_number, 
                   b_1$date[sp_number], ".txt")
    fileConn<-file(path)
    writeLines(text, fileConn)
    close(fileConn)
  Sys.sleep(5) # slows down the files request. 
}
