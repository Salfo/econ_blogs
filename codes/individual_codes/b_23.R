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

url = 'https://theincidentaleconomist.com/'
l_xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "post-title", " " ))]//a'
d_xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "post-date", " " ))]'
b_23 <- extract_links(url = url,
                         l_xpath = l_xpath,
                         d_xpath = d_xpath)

b_23 <- data.frame(date = b_23$date, Links = b_23$links, stringsAsFactors = FALSE)

dd <- str_split_fixed(b_23$date, pattern = 'April', n = 2)[, 2]
dd <- str_trim(dd)
dd <- str_split_fixed(dd, pattern = '2018', n = 2)[, 1]
dd <- paste0("April ", dd, '2018')

b_23$date <- dd

# A function to scrape the texts
sp_number = 0
missing <- NULL
for (url in b_23$Links) {
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
    path <- paste0('data/blog_texts/', "b_23_", sp_number, 
                   b_23$date[sp_number], ".txt")
    fileConn<-file(path)
    writeLines(text, fileConn)
    close(fileConn)
  Sys.sleep(2) # slows down the files request. 
}
