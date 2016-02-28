library(devtools)
devtools::load_all("~/My_Code/ffkill2/ffkill2_depl_win/")

input_file_path <- "RawData/input_file.txt"
output_file_path <- "Temp/dataset_loaded.RData"

txt_to_methylumi_default <- .Curry(txt_to_methylumi, continue_without_control_probes=T)

#---- define default functions
txt_to_methylumi_default <- .Curry(txt_to_methylumi, continue_without_control_probes=T)

#---- load file and save it
res <- .Mreturn(input_file_path) %>>=% txt_to_methylumi_default
saveRDS(res, file=output_file_path)
