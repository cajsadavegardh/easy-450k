.load_yaml_config <- function(config_path) yaml::yaml.load_file(config_path)

.get_filtering_params <- .load_yaml_config

.get_normalization_params <- .load_yaml_config

.get_bmiq_params <- .load_yaml_config

.get_analysis_params <- .load_yaml_config

# Parse phenotype file configs -----
get_phenotype_info <- function(config_path) yaml::yaml.load_file(config_path)

get_phenotype_file_path <- function(config_path) get_phenotype_info(config_path)$phenotype_file

get_batch_column_name <- function(config_path) get_phenotype_info(config_path)$batch_column

get_sample_id_column_name <- function(config_path) get_phenotype_info(config_path)$sample_names_column

get_categorical_covariates_names <- function(config_path) get_phenotype_info(config_path)$covariates$categorical

get_numeric_covariate_names <- function(config_path) get_phenotype_info(config_path)$covariates$numeric

get_phenotypes <- function(config_path) read.delim(get_phenotype_file_path(config_path), stringsAsFactors=F)

