pacman::p_load(data.table, tidyverse, here)

checkStatus <- function(patient, dir_path) {
  tags <- fread("data/studyTableClean.txt") %>%
    mutate(tag_par = paste0("'", tag_par, "'=''"))
  
  tagsCheck <- paste0(tags$tag, collapse = " +P ") 
  
  cmd <- paste0("dcmdump +sd +r ", dir_path, " +P ", tagsCheck, " +U8")
  return(system(cmd, intern = T, ignore.stderr = T))
}
date_folder <- "2022_09_18"
patientList <- list.dirs(here("modify", date_folder), recursive = F, full.names = F)

### Get random patient and study to test
patient <- sample(patientList, 1)
patient_root <- here("modify", date_folder, patient)
patient_dirs <- list.dirs(path = patient_root, recursive = F)
study_path <- sample(patient_dirs, 1)

checkStatus(patient, study_path)

