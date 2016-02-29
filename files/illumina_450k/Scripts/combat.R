bmiq_dataset <- readRDS("Temp/bmiq_dataset.RData")
config_path <- "Configs/config.yaml"
output_file_path <- "Temp/combat_results.RData"

meth_matrix <- get_values(bmiq_dataset[[1]])
annotation <- get_annotation(bmiq_dataset[[1]])
phenotypes_table <- get_phenotypes(config_path)
batch_name <- get_batch_column_name(config_path)
numeric_names <- get_numeric_covariate_names(config_path)
categorical_names <- get_categorical_covariates_names(config_path)
id_column_name <- get_sample_id_column_name(config_path)

# impute phenotypes
phenotypes_table$Hba1c[ is.na(phenotypes_table$Hba1c) ] <- mean(phenotypes_table$Hba1c, na.rm=T)

combat_default <- .Curry(combat, phenotypes_table=phenotypes_table, id_column_name=id_column_name,
batch_name=batch_name, numeric_names=numeric_names, categorical_names=categorical_names)
combat_results <- bmiq_dataset %>>=% combat_default
saveRDS(combat_results, file=output_file_path)
