#' Remove any non-DICOM files from study directory
#' 
#' This is a function which crawls through the study directory for all patients 
#' and deletes any file and folder which is irrelevant to the project (non-DICOM files) 
#' 
#' @param root_folder The root folder which contains all patient directories
#' 

clean_folders <- function(root_folder) {
  ### Get all file paths across all patients
  all_files <- list.files(path = root_folder, all.files = T, recursive = T, full.names = T)
  
  ### Files are either relevant (DICOM images) or irrelevant.
  cmd <- paste0("find ", root_folder, "/ -type f -exec file {} \\; | grep 'DICOM' | sed 's/:.*//'")
  relevant_files <- system(cmd, intern = T)
  irrelevant_files <- all_files[!all_files %in% relevant_files]
  
  ### Phase I: First pass of irrelevant file/folder deletion.
  unlink(x = irrelevant_files, recursive = T)
  
  ### Phase II: Second pass of irrelevant file/folder deletion.
  patient_dirs <- list.dirs(path = root_folder, recursive = T)
  
  for(dir in patient_dirs) {
    unlink(x = here(dir, "HELP"), recursive = T, force = T)
    unlink(x = here(dir, "IHE_PDI"), recursive = T, force = T)
    unlink(x = here(dir, "JRE"), recursive = T, force = T)
    unlink(x = here(dir, "PLUGINS"), recursive = T, force = T)
    unlink(x = here(dir, "REPORT"), recursive = T, force = T)
    unlink(x = here(dir, "XTR_CONT"), recursive = T, force = T)
    ### DICOMDIR file becomes corrupted after anonymizing data.
    unlink(x = here(dir, "DICOMDIR"), recursive = T, force = T)
  }  
}


