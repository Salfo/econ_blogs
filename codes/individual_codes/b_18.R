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

url = 'http://www.interfluidity.com/'
l_xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "post", " " ))] | //*[contains(concat( " ", @class, " " ), concat( " ", "posttitle", " " ))]//a'
d_xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "postmetadata", " " ))]'
b_18 <- extract_links(url = url,
                         l_xpath = l_xpath,
                         d_xpath = d_xpath)

b_18 <- data.frame(date = b_18$date, Links = b_18$links)
date <- b_18$date[c(seq(1,19, 2))]
Links <- b_18$Links[c(seq(2,20, 2))]
b_18 <- data.frame(date = date, Links = Links)
  
dd <- str_split_fixed(b_18$date, pattern = ",", n =2)
dd <- str_split_fixed(dd[, 2], pattern = "at", n =2)
dd <- str_trim(dd[, 1])
b_18$date <- dd

# A function to scrape the texts
sp_number = 0
missing <- NULL
for (url in b_18$Links) {
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
    path <- paste0('data/blog_texts/', "b_18_", sp_number, 
                   b_18$date[sp_number], ".txt")
    fileConn<-file(path)
    writeLines(text, fileConn)
    close(fileConn)
  Sys.sleep(2) # slows down the files request. 
}
