pacman::p_load(data.table, here, tidyverse)

tags <- fread(here("data", "studyTableClean.txt")) %>%
  mutate(tag_par = paste0("'", tag_par, "'=''"))

extraTags <- paste0(tags$tag_par, collapse = " -ma ")

modifyPatient <- function(patient) {
  
  print(paste0("PROCESSING PATIENT: ", patient))
  patientName <- paste0("'(0010,0010)'='", patient, "'")
  patientID <- paste0("'(0010,0020)'='", patient, "'")
  filePath <- list.files(path = here("modify", patient), full.names = T, recursive = T)
  
  for (pathZ in filePath) {
    ### Overwrite patient name, patient ID and 
    ### all extra tags as specified in protocol
    cmd <- paste0("dcmodify -nb -ie ", pathZ, " -ma ", patientName, 
                  " -ma ", patientID, 
                  " -ma ", extraTags)
    system(cmd, ignore.stderr = T)
  }
}

patientList <- list.dirs(here("modify"), recursive = F, full.names = F)

for (patient in patientList) {
  modifyPatient(patient = patient)  
}

