# write a function that will verify analysis config (and all configs for this matter)
# here go this function

# now that we know that the analysis config is correct, please parse it and call analysis
combat_results <- readRDS(defaults$combat_path)
res <- combat_results %>>=% defaults$run_analysis_default

## add this analysis columns to the final output part
#combat_output

saveRDS(res, defaults$analyzed_path)
