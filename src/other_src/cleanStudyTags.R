### Load relevant libraries
pacman::p_load(data.table, tidyverse, here)

### Load study tags table and fix formatting for dcmtk
studyTags <- fread("data/studytags.csv")

studyTags <- 
  studyTags %>%
  separate(col = TAG, into = c('junk', 'tag'), sep = "X") %>%
  mutate(tag = paste0(str_sub(string = tag, start = 1, end = 4),
                       ",",
                       str_sub(string = tag, start = 5, end = 8))) %>%
  select(name = NAME, tag) %>%
  mutate(tag_par = paste0("(", tag, ")"))

### Export
write.table(x = studyTags, 
            file = here("data", "studyTableClean.txt"), 
            quote = F, row.names = F, sep = "\t")
