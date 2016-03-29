defaults <- new.env()

##------- Default file locations
defaults$raw_data_path <- "RawData/input_file.txt"
defaults$loaded_dataset_path <- "Temp/dataset_loaded.RData"
defaults$preprocessed_dataset_path <- "Temp/preprocessed_dataset.RData"
defaults$bmiq_path <- "Temp/bmiq_dataset.RData"
defaults$combat_path <- "Temp/combat_results.RData"

##------- Config file locations
defaults$probe_filetring_config_path <- "Configs/probe_filtering.yaml"
defaults$normalization_config_path <- "Configs/normalization.yaml"
defaults$sample_list_path <- "Configs/analysis_samples.txt"
defaults$bmiq_config_path <- "Configs/bmiq.yaml"
defaults$combat_config_path <- "Configs/combat.yaml"

##------- Loading stage default functions
defaults$txt_to_methylumi_default <- Curry(txt_to_methylumi, continue_without_control_probes=T)

##------ Normalization stage default functions
defaults$filter_config_params <- get_filtering_params(defaults$probe_filetring_config_path)
defaults$normalization_config_params <- get_normalization_params(defaults$normalization_config_path)
defaults$filter_samples_default <- Curry(filter_samples, samples_list_path=defaults$sample_list_path)
defaults$filter_probes_default <- Curry(filter_probes, config=defaults$filter_config_params)
defaults$normalize_default <- Curry(normalize, config=defaults$normalization_config_params)

#-------- BMIQ default function
defaults$bmiq_params <- get_bmiq_params(defaults$bmiq_config_path)
defaults$bmiq_default <- Curry(bmiq, bmiq_config=defaults$bmiq_params)

#--------- Combat default functions
defaults$combat_phenotypes_table <- get_phenotypes(defaults$combat_config_path)
defaults$combat_batch_name <- get_batch_column_name(defaults$combat_config_path)
defaults$combat_numeric_names <- get_numeric_covariate_names(defaults$combat_config_path)
defaults$combat_categorical_names <- get_categorical_covariates_names(defaults$combat_config_path)
defaults$combat_id_column_name <- get_sample_id_column_name(defaults$combat_config_path)

defaults$combat_default <- Curry(combat,
    phenotypes_table=defaults$combat_phenotypes_table,
    id_column_name=defaults$combat_id_column_name,
    batch_name=defaults$combat_batch_name,
    numeric_names=defaults$combat_numeric_names,
    categorical_names=defaults$combat_categorical_names)
