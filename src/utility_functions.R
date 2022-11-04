get_study_id_from_path <- function(dir_path) {
  ### Patient studies are stored in folders with the following naming scheme:
  ### /patient_id/patient_id<STUDY>
  ### We need to harvest the <STUDY> identity.
  path_split <- str_split(string = dir_path, pattern = "\\/", simplify = T)
  n_substrings <- ncol(path_split)
  
  ### After splitting the directory path on / we grab the patient ID and use it
  ### to get and clean the study ID.
  patient_id <- path_split[1, (n_substrings - 1)]
  patient_study_id <- path_split[1, n_substrings]
  patient_study_id <- gsub(pattern = patient_id, replacement = "", x = patient_study_id)
  return(patient_study_id)
}
