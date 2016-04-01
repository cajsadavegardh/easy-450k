bmiq_dataset <- readRDS("Temp/bmiq_dataset.RData")

##meth_matrix <- get_values(bmiq_dataset[[1]])
##annotation <- get_annotation(bmiq_dataset[[1]])

combat_results <- bmiq_dataset %>>=% defaults$combat_default
saveRDS(combat_results, file=defaults$combat_path)
