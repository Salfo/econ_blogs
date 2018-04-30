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

url = 'http://www.themoneyillusion.com/'
l_xpath = '//h1//a'
d_xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "postmetadata", " " ))]'
b_9 <- extract_links(url = url,
                         l_xpath = l_xpath,
                         d_xpath = d_xpath)
#Links <- unlist(b_9$links)[seq(2, 20, 2)]
b_9 <- data.frame(date = b_9$date, Links = b_9$links)
ff <- str_split_fixed(b_9$date, pattern = '2018', n= 2)
b_9$date <- paste0(ff[, 1], 2018)


# A function to scrape the texts
sp_number = 0
missing <- NULL
for (url in b_9$Links) {
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
    path <- paste0('data/blog_texts/', "b_9_", sp_number, 
                   b_9$date[sp_number], ".txt")
    fileConn<-file(path)
    writeLines(text, fileConn)
    close(fileConn)
  Sys.sleep(2) # slows down the files request. 
}
