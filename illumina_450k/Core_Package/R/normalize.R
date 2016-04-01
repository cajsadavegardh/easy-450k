normalize <- function(ml_object, config) {
    log <- paste("Performing normalization procedures")
    wm_ml_object <- MonadWriter(ml_object, log)

    norms <- list()

    if(!is.null(config$background_correct) & config$background_correct)
        norms <- c(norms, .background_correct)

    if(!is.null(config$adjust_color_bias) & config$adjust_color_bias)
        norms <- c(norms, .adjust_color_bias)

    if(!is.null(config$quantile_normalize) & config$quantile_normalize)
        norms <- c(norms, .quantile_normalize)

    Reduce(`%>>=%`, norms, wm_ml_object)
}

.background_correct <- function(ml_object) {
    log <- paste("Performing background correction")
    ml_object <- .ml_background_correct(ml_object)
    MonadWriter(ml_object, log)
}

.adjust_color_bias <- function(ml_object) {
    log <- paste("Adjustring color bias")
    ml_object <- .ml_color_adjust(ml_object)
    MonadWriter(ml_object, log)
}

.quantile_normalize <- function(ml_object) {
    log <- paste("Performing quantile normalization")
    ml_object <- .ml_quantile_normalize(ml_object)
    MonadWriter(ml_object, log)
}