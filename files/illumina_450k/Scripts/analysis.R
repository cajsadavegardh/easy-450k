# parse files
combat_results_path <- "Temp/combat_results.RData"
analysis_config_path <- "Configs/analysis.yaml"

# load analysis yaml
analysis_params <- .get_analysis_params(analysis_config_path)

# load phenotypes
pheno_config_path <- "Configs/phenotype_info.yaml"
phenotypes_table <- get_phenotypes(pheno_config_path)

# load dataset
combat_results <- readRDS(combat_results_path)

# write a function that will verify analysis config (and all configs for this matter)
# here go this function

# now that we know that the analysis config is correct, please parse it and call analysis
n_cores <- analysis_params$n_cores
perform_fdr <- T

if(analysis_params$type == "lm") {
    numeric_names <- analysis_params$covariates$numeric
    categorical_names <- analysis_params$covariates$categorical
    run_lm_default <- Curry(run_lm, n_cores=n_cores, perform_fdr=perform_fdr, phenotypes_table=phenotypes_table, numeric_names=numeric_names, categorical_names=categorical_names)
    res <- combat_results %>>=% run_lm_default
} else if (analysis_params$type == "wilcoxon") {
    group <- get(analysis_params$group, phenotypes_table)
    group <- as.numeric(as.factor(group))
    if(!(all(group %in% c(1, 2)))) stop("More then 2 groups provided for wilcoxon test")
    run_wilcoxon_default <- Curry(run_wilcoxon, n_cores=40, perform_fdr=T, group=group, paired=F, exact=F, correct=T)
    res <- combat_results %>>=% run_lm_default
} else {
    stop("Unknown analysis type")
}

## add this analysis columns to the final output part
#combat_output

saveRDS(res, file="Results/analyzed_dataset.RData")
