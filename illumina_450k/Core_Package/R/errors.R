# Input phenotype info related errors --------
.na_phenotypes_error <- simpleError("Some of the phenotypes contain missing values. Filter your samples or impute!")

.missmached_batch_name_error <- simpleError("Cannot find a specified batch name in the phenotype")

.missmached_numeric_cols_error <- simpleError("Cannot find a specified numeric column names in the phenotype file")

.missmached_categorical_cols_error <- simpleError("Cannot find a specified categorical column names in the phenotype file")

.missmached_id_col_error <- simpleError("Cannot find a specified id column names in the phenotype file, or some ids are missing")

.missmatched_combat_phenotypes_error <- simpleError("Phenotype table provided for combat has different dimensions from data matrix")
