#' Remove any information which can be used to identify patient
#' 
#' This is a function which goes through the metadata of a patient's DICOM study 
#' and removes any information which can be used to identify them as well as any
#' extra tags which have specified.
#' 
#' @param patient The patient ID.
#' @param study_id The study ID for a given patient.
#' @param dir_path The path to the patient's study.
#' @param extra_tags Any extra tags which are to be anonymized.

modify_patient_dicom_metadata <- function(patient, study_id, dir_path, extra_tags) {
  
  print(paste0("PROCESSING PATIENT: ", patient))
  patient_name <- paste0("'(0010,0010)'='", patient, "'")
  patient_ID <- paste0("'(0010,0020)'='", patient, "_", study_id, "'")
  image_path <- list.files(path = dir_path, full.names = T, recursive = T)
  
  for (path_z in image_path) {
    ### Overwrite patient name, patient ID and 
    ### all extra tags as specified in protocol
    cmd <- paste0("dcmodify -nb -ie ", path_z, " -ma ", patient_name, 
                  " -ma ", patient_ID, 
                  " -ma ", extra_tags)
    system(cmd, ignore.stderr = T)
  }
}


