##############################
#### run_anonymization.R #####
##############################

### Load relevant libraries and functions
pacman::p_load(here, data.table, tidyverse)

source(here("src", "utility_functions.R"))
source(here("src", "clean_dicom_folders.R"))
source(here("src", "modify_patient_DICOM_metadata.R"))

### DICOM tags
tags <- 
  fread(here("data", "studyTableClean.txt")) %>%
  mutate(tag_par = paste0("'", tag_par, "'=''"))

extra_tags <- paste0(tags$tag_par, collapse = " -ma ")

### Remove any irrelevant files and folders from study folders
clean_folders(root_folder = here("modify"))

### Anonymize DICOM metadata
patient_list <- list.dirs(here("modify"), recursive = F, full.names = F)

for (patient in patient_list) {
  patient_root <- here("modify", patient)
  patient_dirs <- list.dirs(path = patient_root, recursive = F)
  for (sub_dir in patient_dirs) {
    study_id <- get_study_id_from_path(sub_dir)
    modify_patient_dicom_metadata(patient = patient, 
                   study_id = study_id, 
                   dir_path = sub_dir, 
                   extra_tags = extra_tags)  
  }
}
