#' Filter samples in the dataset based on txt file:
#' Takes methylumi object and txt config file with sample names, one per line
#' Returns filtered 'monadic' methylumi object with log
#'

filter_samples <- function(ml_object, samples_list_path) {
    sample_names <- readLines(samples_list_path)
    stopifnot(all(sample_names %in% .get_sample_names(ml_object)))
    log <- paste("Selecting", length(sample_names), "out of", length(.get_sample_names(ml_object)), "samples for further analysis")
    MonadWriter(ml_object[,sample_names], log)
}