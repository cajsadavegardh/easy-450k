#---- load file and save it
res <- Mreturn(defaults$raw_data_path) %>>=% defaults$txt_to_methylumi_default
saveRDS(res, file=defaults$loaded_dataset_path)
