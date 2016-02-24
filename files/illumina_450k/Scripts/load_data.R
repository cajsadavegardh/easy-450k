file_path <- "RawData/input_file.txt"
methylumi_object <- txt_to_methylumi(file_path)
saveRDS(methylumi_object, file = "Temp/methylumi_loaded.RData")