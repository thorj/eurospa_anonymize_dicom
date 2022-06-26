pacman::p_load(data.table, tidyverse, here)

checkStatus <- function(patient) {
  tags <- fread("data/studyTableClean.txt") %>%
    mutate(tag_par = paste0("'", tag_par, "'=''"))
  
  tagsCheck <- paste0(tags$tag, collapse = " +P ") 
  
  cmd <- paste0("dcmdump +sd +r ", here("modify", patient), " +P ", tagsCheck, " +U8")
  return(system(cmd, intern = T, ignore.stderr = T))
}

patientList <- list.dirs(here("modify"), recursive = F, full.names = F)
checkStatus(patientList[5])

