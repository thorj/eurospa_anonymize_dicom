pacman::p_load(tidyverse, lubridate, here)

summarize_folders <- function(patient) {
  patient_root <- here("export", patient)  
  patient_dirs <- list.dirs(path = patient_root, recursive = F)
  #print(patient_dirs)
  patient_summary <- list()
  for (i in 1:length(patient_dirs)) {
    sub_dir <- patient_dirs[i]
    patient_files <- list.files(path = sub_dir, all.files = T, recursive = T, full.names = T)
    patient_summary[[i]] <- length(patient_files)
  }
  patient_study <- str_split_fixed(string = patient_dirs, pattern = "/", n = Inf)
  patient_study <- patient_study[, ncol(patient_study)]
  out <- data.frame(patient = rep(patient, length(patient_dirs)), 
                    study = patient_study,
                    number_files = unlist(patient_summary))
  return(out)
}

export_summary <- function(summary_data, patient_type, date, batch_num) {
  export_name <- sprintf("landspitali_type_%s_batch_%s_%s.csv", patient_type, batch_num, date)
  write.csv(x = summary_data, file = here("data", export_name), quote = F, row.names = F)
}

patientList <- list.dirs(here("modify", gsub("-", "_", today())), recursive = F, full.names = F)

res <- lapply(X = patientList, FUN = summarize_folders)
out <- do.call(rbind, res)

export_summary(out, "PSA", gsub("-", "_", today()), 2)

read_summary <- read_csv("data/landspitali_type_PSA_batch_2_2022_09_18.csv")

unique(read_summary$patient) %>% length()

sum(read_summary$number_files)
