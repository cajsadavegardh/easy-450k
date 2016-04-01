#' @export
txt_to_methylumi <- function(file_path, continue_without_beta=F, continue_without_control_probes=F) {
    stopifnot(file.exists(file_path))
    stopifnot(.check_signal_a(file_path))
    stopifnot(.check_signal_b(file_path))
    stopifnot(.check_beta(file_path) | continue_without_beta )
    stopifnot(.has_control_probes(file_path) | continue_without_control_probes)
    ml_object <- lumi::lumiMethyR(file_path)
    ml_object <- .add_extra_annotation(ml_object)
    MonadWriter(ml_object, paste("Loaded file", file_path))
}

.add_extra_annotation <- function(ml_object) {
    # add extra annotation to the object
    ml_object <- .merge_df_to_annotation(ml_object, chen, "TargetID")
    ml_object <- .merge_df_to_annotation(ml_object, price, "ID")
    ml_object
}

# check if beta value columns are present in the file_path
.check_beta <- function(file_path) .check_in_header("AVG_Beta", file_path)

.check_detection_pvals <- function(file_path) .check_in_header("Detection", file_path)

.check_signal_a <- function(file_path) .check_in_header("Signal_A", file_path)

.check_signal_b <- function(file_path) .check_in_header("Signal_B", file_path)

.check_in_header <- function(str, file_path) grepl(str, .get_header(file_path))

.get_header <- function(file_path) {
    con <- file(file_path, open = 'r')
    on.exit(close(con))

    # read while line != [Sample Methylation Profile]
    while(length(line <- readLines(con, n=1, warn=FALSE)) > 0) {
        if(trimws(line) == '[Sample Methylation Profile]') {
            line <- readLines(con, n=1, warn=FALSE)
            return(line)
        }
    }
}

.has_control_probes <- function(file_path) {
    con <- file(file_path, open='r')
    on.exit(close(con))

    i <- 0
    while(length(line <- readLines(con, n=1, warn=FALSE)) > 0) {
        i <- i + 1
        if(i != 485587) next
        return(ifelse((line == '[Control Probe Profile]'), T, F))
    }
    F
}