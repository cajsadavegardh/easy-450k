library(devtools)
devtools::load_all("~/My_Code/ffkill2_devfiles/ffkill2_deployment_mac/")

input_file_path <- "RawData/input_file.txt"
config_path <- "Configs/config.yaml"
sample_list_path <- "Configs/analysis_samples.txt"
output_file_path <- "Temp/bmiq_results.RData"

#---- define default functions
txt_to_methylumi_default <- .Curry(txt_to_methylumi, continue_without_control_probes=T)
filter_samples_default <- .Curry(filter_samples, samples_list_path=sample_list_path)
filter_probes_default <- .Curry(filter_probes, config_path=config_path)
normalize_default <- .Curry(normalize, config_path=config_path)

#---- run the whole pipeline

res <- .Mreturn(input_file_path) %>>=%
                txt_to_methylumi_default %>>=%
#               filter_samples_default %>>=%
                filter_probes_default  %>>=%
                normalize_default

print(res[[2]])

saveRDS(res, file="Temp/bmiq_results.RData")
