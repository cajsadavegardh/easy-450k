#' bmiq is run with default parameters for now
#' it will also change the format of the propagated ml_object
#' that will keep the annotation and value matrix separately
bmiq <- function(ml_object, bmiq_config) {
    do.call(.bmiq, c(list(ml_object=ml_object), bmiq_config))
}

.bmiq <- function(ml_object, n_cores=1, nfit=50000, seed=1) {
    design_probes <- .get_probe_types(ml_object)
    beta_values <- .get_betas(ml_object)

    if(n_cores > 1) {
        doMC::registerDoMC(n_cores)
    }

    bmiq_matrix <- as.data.frame(foreach(sample=iter(beta_values)) %dopar% {
        capture.output(normalized_sample <- BMIQ(sample, design_probes, seed=seed, nfit=nfit)$all)
        normalized_sample
    })
    bmiq_matrix <- .beta_to_m(bmiq_matrix)
    colnames(bmiq_matrix) <- colnames(beta_values)

    annotation <- .get_ml_annotation(ml_object)
    dataset <- Dataset(bmiq_matrix, annotation)
    MonadWriter(dataset, "Performed BMIQ")
}