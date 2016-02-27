library(ffkill2)

infput_file_path <- "RawData/input_file.txt"
config_path <- "Configs/config_path.yaml"
sample_list_path <- "Configs/analysis_samples.txt"

#---- define default functions

txt_to_methylumi_default <- .Curry(txt_to_methylumi, continue_without_control_probes=T)
filter_samples_default <- .Curry(filter_samples, samples_list_path=sample_list_path)
filter_probes <- .Curry(filter_probes, config_path=config_path)
normalize <- .Curry(normalize, config_path=config_path)

#---- run the whole pipeline

res <= .Mreturn(file_path) >>=%
               txt_to_methylumi_default %>>=%
#               filter_samples_default %>>=%
               filter_probes  %>>=%
               normalize