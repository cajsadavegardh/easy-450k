library(devtools)
devtools::load_all("~/My_Code/ffkill2/ffkill2_depl_win/")

input_file_path <- "Temp/dataset_loaded.RData"
config_path <- "Configs/config.yaml"
sample_list_path <- "Configs/analysis_samples.txt"
output_file_path <- "Temp/preprocessed_dataset.RData"

#---- define default functions
txt_to_methylumi_default <- .Curry(txt_to_methylumi, continue_without_control_probes=T)
filter_samples_default <- .Curry(filter_samples, samples_list_path=sample_list_path)
filter_probes_default <- .Curry(filter_probes, config_path=config_path)
normalize_default <- .Curry(normalize, config_path=config_path)

#---- run the whole pipeline
loaded_data <- readRDS(input_file_path)

normalized_dataset <- loaded_data %>>=%
#       filter_samples_default %>>=%
       filter_probes_default  %>>=%
       normalize_default

print(normalized_dataset[[2]])
saveRDS(normalized_dataset, file=output_file_path)
