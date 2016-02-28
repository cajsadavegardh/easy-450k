.get_filtering_params <- function(config_path) yaml::yaml.load_file(config_path)$probe_filtering

.get_normalization_params <- function(config_path) yaml::yaml.load_file(config_path)$normalization

.get_bmiq_params <- function(config_path) yaml::yaml.load_file(config_path)$bmiq
