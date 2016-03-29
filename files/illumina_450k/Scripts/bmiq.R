loaded_data <- readRDS(defaults$preprocessed_dataset_path)

#---- run the pipeline
normalized_dataset <- loaded_data %>>=% defaults$bmiq_default

saveRDS(normalized_dataset, file=defaults$bmiq_path)
