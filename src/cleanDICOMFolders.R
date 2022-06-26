pacman::p_load(here)

cleanFolders <- function(modRoot) {
  allFiles <- list.files(path = modRoot, all.files = T, recursive = T, full.names = T)
  cmd <- paste0("find ", modRoot, "/ -type f -exec file {} \\; | grep 'DICOM' | sed 's/:.*//'")
  relFiles <- system(cmd, intern = T)
  
  test <- 
    tibble(allFiles) %>%
    filter(!allFiles %in% relFiles)
  
  unlink(x = test$allFiles, recursive = T)
  
  patientDirs <- list.dirs(path = modRoot, recursive = F)
  
  for(dir in patientDirs) {
    unlink(x = here(dir, "HELP"), recursive = T, force = T)
    unlink(x = here(dir, "IHE_PDI"), recursive = T, force = T)
    unlink(x = here(dir, "JRE"), recursive = T, force = T)
    unlink(x = here(dir, "PLUGINS"), recursive = T, force = T)
    unlink(x = here(dir, "REPORT"), recursive = T, force = T)
    unlink(x = here(dir, "XTR_CONT"), recursive = T, force = T)  
  }  
}

cleanFolders(modRoot = here("modify"))

