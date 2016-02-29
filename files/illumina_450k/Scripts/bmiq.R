input_file_path <- "Temp/preprocessed_dataset.RData"
config_path <- "Configs/config.yaml"
output_file_path <- "Temp/bmiq_dataset.RData"

#--- load config
bmiq_params <- .get_bmiq_params(config_path)

#---- define function calls
bmiq_default <- .Curry(bmiq, bmiq_config=bmiq_params) #!---- change

#---- load persisted dataset
loaded_data <- readRDS(input_file_path)

#---- run the pipeline
normalized_dataset <- loaded_data %>>=% bmiq_default

saveRDS(normalized_dataset, file=output_file_path)
