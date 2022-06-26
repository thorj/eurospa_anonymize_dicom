### Load relevant libraries
pacman::p_load(rvest, polite, tidyverse, stringi, here)

### Scrape politely
session <- bow("https://dicom.nema.org/medical/dicom/current/output/html/part15.html#chapter_E")
result <- scrape(bow = session)

tbl1 <- 
  result %>%
  html_nodes(xpath = "/html/body/div/div[18]/div[3]/div[4]/div[5]/div/table") %>%
  html_table()
tbl1 <- tbl1[[1]]

### Filter results and fix tags for dcmtk
out <- 
  tbl1 %>%
  select(atr_name = 1, tag = 2) %>%
  mutate(tag = stri_replace_all_regex(tag, 
                                         pattern = c('\\(', '\\)'), 
                                         replacement = c('', ''),
                                         vectorise_all = F))

### Export to data/
write.table(x = out, 
            file = here("data", "dicomTags.txt"), 
            quote = F, sep = ";", row.names = F)
