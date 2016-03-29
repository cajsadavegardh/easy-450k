loaded_data <- readRDS(defaults$loaded_dataset_path)

normalized_dataset <- loaded_data %>>=%
       defaults$filter_samples_default %>>=%
       defaults$filter_probes_default  %>>=%
       defaults$normalize_default

saveRDS(normalized_dataset, file=defaults$preprocessed_dataset_path)
