input_file_path <- "Temp/dataset_loaded.RData"
probe_filetring_config_path <- "Configs/probe_filtering.yaml"
normalization_config_path <- "Configs/normalization.yaml"
sample_list_path <- "Configs/analysis_samples.txt"
output_file_path <- "Temp/preprocessed_dataset.RData"

#--- load config
filter_config_params <- .get_filtering_params(probe_filetring_config_path)
normalization_config_params <- .get_normalization_params(normalization_config_path)

#---- define function calls
txt_to_methylumi_default <- .Curry(txt_to_methylumi, continue_without_control_probes=T)
filter_samples_default <- .Curry(filter_samples, samples_list_path=sample_list_path)
filter_probes_default <- .Curry(filter_probes, config=filter_config_params)
normalize_default <- .Curry(normalize, config=normalization_config_params)

#---- run the whole pipeline
loaded_data <- readRDS(input_file_path)

normalized_dataset <- loaded_data %>>=%
       filter_samples_default %>>=%
       filter_probes_default  %>>=%
       normalize_default

print(normalized_dataset[[2]])
saveRDS(normalized_dataset, file=output_file_path)
