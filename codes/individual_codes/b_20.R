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

url = 'https://www.epi.org/blog/'
l_xpath = '//h2//a'
d_xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "blog-byline", " " ))]'
b_20 <- extract_links(url = url,
                         l_xpath = l_xpath,
                         d_xpath = d_xpath)

b_20 <- data.frame(date = b_20$date, Links = b_20$links)

dd <- str_split_fixed(b_20$date, pattern = 'at', n = 2)[, 1]
dd <- str_split_fixed(dd, pattern = 'Posted ', n = 2)[, 2]
dd <- str_trim(dd)

b_20$date <- dd

# A function to scrape the texts
sp_number = 0
missing <- NULL
for (url in b_20$Links) {
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
    path <- paste0('data/blog_texts/', "b_20_", sp_number, 
                   b_20$date[sp_number], ".txt")
    fileConn<-file(path)
    writeLines(text, fileConn)
    close(fileConn)
  Sys.sleep(2) # slows down the files request. 
}
