#' Filter probes in the dataset based on yaml script:
#' Takes 'monadic' methylumi object and yaml script
#' Returns filtered 'monadic' methylumi object w
#'

#' @export
filter_probes <- function(ml_object, config) {
    # write to log which config_path we're parsing
    log <- paste("Filtering probes...") #, paste(names(config_params), ": ", config_params, ", ", sep = ""))
    wm_ml_object <- MonadWriter(ml_object, log)

    # load config and validate it
    stopifnot(all(names(config) %in% .availabe_filters()))

    # call the actual filters
    # Detection pvalues (mean)
    if(!is.null(config$mean_detection))
        wm_ml_object <- wm_ml_object %>>=% Curry(.filter_det_pvals_mean, mean_threshold=config$mean_detection)

    # Detection pvalues (min)
    if(!is.null(config$min_detection))
        wm_ml_object <- wm_ml_object %>>=% Curry(.filter_det_pvals_min, min_threshold=config$min_detection)

    # X chr probes
    if(!is.null(config$x_chr) & config$x_chr)
        wm_ml_object <- wm_ml_object %>>=% .filter_x

    # Y chr probes
    if(!is.null(config$y_chr) & config$y_chr)
        wm_ml_object <- wm_ml_object %>>=% .filter_y

    # SNP (rs) probes
    if(!is.null(config$rs_probes) & config$rs_probes)
        wm_ml_object <- wm_ml_object %>>=% .filter_rs_probes

    # non CpG (ch*) probes
    if(!is.null(config$ch_probes) & config$ch_probes)
        wm_ml_object <- wm_ml_object %>>=% .filter_ch_probes

    # Probes with SNPs in targets
    if(!is.null(config$snp_targets))
        wm_ml_object <- wm_ml_object %>>=% Curry(.filter_snp_targets, maf_threshold=config$snp_targets)

    # cross reactive probes (Chen et al)
    if(!is.null(config$cross_reactive))
        wm_ml_object <- wm_ml_object %>>=% Curry(.filter_cross_reactive, threshold=config$cross_reactive)

    wm_ml_object
}

.availabe_filters <- function() c("mean_detection",
                                  "min_detection",
                                  "rs_probes",
                                  "ch_probes",
                                  "snp_targets",
                                  "cross_reactive",
                                  "x_chr",
                                  "y_chr")

.filter_x <- function(ml_object) {
    probes_to_filter <- .get_ml_annotation(ml_object)$CHR == "X"
    log <- paste("Filtered",
                 length(which(probes_to_filter)),
                 "X chromosome probes.")
    MonadWriter(ml_object[!probes_to_filter, ], log)
}

.filter_y <- function(ml_object) {
    probes_to_filter <- .get_ml_annotation(ml_object)$CHR == "Y"
    log <- paste("Filtered",
                 length(which(probes_to_filter)),
                 "Y chromosome probes.")
    MonadWriter(ml_object[!probes_to_filter, ], log)
}

.filter_det_pvals_mean <- function(ml_object, mean_threshold) {
    pvals <- .get_det_pvals(ml_object)
    probes_to_filter <- apply(pvals, 1, mean) > mean_threshold
    log <- paste("Filtered",
                 length(which(probes_to_filter)),
                 "probes on detection pvalue with mean threshold",
                 mean_threshold)
    MonadWriter(ml_object[!probes_to_filter,], log)
}

.filter_det_pvals_min <- function(ml_object, min_threshold) {
    pvals <- .get_det_pvals(ml_object)
    probes_to_filter <- apply(pvals, 1, min) > min_threshold
    log <- paste("Filtered",
                 length(which(probes_to_filter)),
                 "probes on detection pvalue with min threshold",
                 min_threshold)
    MonadWriter(ml_object[!probes_to_filter, ], log)
}

.filter_cross_reactive <- function(ml_object, threshold) {
    log <- "No filtering based on crossreactivity"
    if(threshold > 50) return(MonadWriter(ml_object, ))
    if(threshold < 47) threshold = 47
    probes_to_filter <- Reduce(`&`, lapply(threshold:50, function(x) {
        colname <- paste("chen_n_cr_", threshold, sep = "")
        col <- get(colname, .get_ml_annotation(ml_object))
        col >= 1 & !is.na(col)
    }))
    n_filtered <- length(which(probes_to_filter))
    log <- paste("Filtered", n_filtered, "probes based on at least", threshold, "crossreactivity (Chen et al)")
    MonadWriter(ml_object[!probes_to_filter, ], log)
}

#' legacy mode is based on legacy annotation of MAF, as Price et al don't provide MAF themselves
#' new MAF filtering should always be used in new projects
#' and there will be no option to use legacy_mode in the future
.filter_snp_targets <- function(ml_object, maf_threshold, legacy_mode=T) {
    stopifnot(legacy_mode) # not implemented yet
    log <- "No filtering based on SNPs in probe target"
    annotation <- .get_ml_annotation(ml_object)

    ## legacy mode filtering
    n_SNPprobe_price <- annotation$n_SNPprobe_price
    max_maf_price <- annotation$legacy_max_maf_price
    probes_to_filter <- max_maf_price >= maf_threshold & !(is.na(max_maf_price))
    n_filtered <- length(which(probes_to_filter))
    log <- paste("Filtered", n_filtered, "probes based on at least", maf_threshold, "MAF (Price et al)")

    MonadWriter(ml_object[!probes_to_filter, ], log)
}

.filter_rs_probes <- function(ml_object) {
    probes_to_filter <- grepl("rs", .get_ml_annotation(ml_object)$TargetID, ignore.case = FALSE)
    log <- paste("Filtered",
                 length(which(probes_to_filter)),
                 "rs probes")
    MonadWriter(ml_object[!probes_to_filter, ], log)
}

.filter_ch_probes <- function(ml_object) {
    probes_to_filter <- grepl("ch", .get_ml_annotation(ml_object)$TargetID, ignore.case = FALSE)
    log <- paste("Filtered",
                 length(which(probes_to_filter)),
                 "ch probes")
    MonadWriter(ml_object[!probes_to_filter, ], log)
}