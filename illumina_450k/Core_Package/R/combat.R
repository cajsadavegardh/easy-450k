#' meth object - a list with 2 elements, beta-value and annotation
#' phenotypes - a data.frame with
#' batch name - a name of the columns
combat <- function(meth_dataset, phenotypes_table, batch_name, id_column_name, numeric_names=NULL, categorical_names=NULL) {
    ## extract methylation matrix from datataset
    meth_matrix <- get_values(meth_dataset)

    ## do extra checking if all columns are in place
    if(!(id_column_name %in% names(phenotypes_table))) stop(.missmached_id_col_error)
    if(!(batch_name %in% names(phenotypes_table))) stop(.missmached_batch_name_error)
    if(!(all(numeric_names %in% names(phenotypes_table)))) stop(.missmached_numeric_cols_error)
    if(!(all(categorical_names %in% names(phenotypes_table)))) stop(.missmached_categorical_cols_error)

    ## select only required columns for further analysis
    phenotypes_table <- phenotypes_table[, c(id_column_name, batch_name, numeric_names, categorical_names)]

    ## reorder methylation matrix according to phenotypes if possible.
    ## all samples should be both in phenotype table in meth_matrix
    ids <- get(id_column_name, phenotypes_table)
    if(nrow(phenotypes_table) != ncol(meth_matrix)) stop(.missmatched_combat_phenotypes_error)
    if(!(all(ids %in% colnames(meth_matrix)))) stop(.missmached_id_col_error)
    if(!(all(colnames(meth_matrix) %in% ids))) stop(.missmached_id_col_error)

    ## check that there is no missing values in the phenotypes
    ## users should manually deal with missing values
    if(any(is.na(phenotypes_table))) stop(.na_phenotypes_error)

    phenotypes_table[, categorical_names] <- apply(phenotypes_table[, categorical_names], 2, as.factor)
    phenotypes_table[, numeric_names] <-  apply(phenotypes_table[, numeric_names], 2, as.numeric)

    cov_formula <- paste("~ ", paste(c(numeric_names, categorical_names), collapse=" + "))
    cov_formula <- as.formula(cov_formula)
    print(cov_formula)

    #batch correction
    mod <- model.matrix(cov_formula, data=phenotypes_table)
    batch <- get(batch_name, phenotypes_table)
    corrected_data <- sva::ComBat(dat=meth_matrix, batch=get(batch_name, phenotypes_table), mod=mod) #, numCovs=1:length(numeric_names))
    meth_dataset <- set_values(meth_dataset, as.data.frame(corrected_data))
    log <- paste("Perormed ComBat with model", gsub("\\s+", " ", Reduce(paste, deparse(cov_formula))))
    MonadWriter(meth_dataset, log)
}
