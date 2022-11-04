pacman::p_load(data.table, here, tidyverse)

tags <- fread(here("data", "studyTableClean.txt")) %>%
  mutate(tag_par = paste0("'", tag_par, "'=''"))

extraTags <- paste0(tags$tag_par, collapse = " -ma ")

modifyPatient <- function(patient, dir_path) {
  
  print(paste0("PROCESSING PATIENT: ", patient))
  patientName <- paste0("'(0010,0010)'='", patient, "'")
  patientID <- paste0("'(0010,0020)'='", patient, "'")
  filePath <- list.files(path = dir_path, full.names = T, recursive = T)
  
  for (pathZ in filePath) {
    ### Overwrite patient name, patient ID and 
    ### all extra tags as specified in protocol
    cmd <- paste0("dcmodify -nb -ie ", pathZ, " -ma ", patientName, 
                  " -ma ", patientID, 
                  " -ma ", extraTags)
    system(cmd, ignore.stderr = T)
  }
}

date_folder <- "2022_09_18"

patientList <- list.dirs(here("modify", date_folder), recursive = F, full.names = F)

for (patient in patientList) {
  patient_root <- here("modify", date_folder, patient)
  patient_dirs <- list.dirs(path = patient_root, recursive = F)
  for (sub_dir in patient_dirs) {
    modifyPatient(patient = patient, dir_path = sub_dir)  
  }
}

