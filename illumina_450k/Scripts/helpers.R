format_log <- function(monad_writer) {
    log <- strsplit(monad_writer[[2]], "\\s+>>=\\s+")[[1]]
    if(log[1] == "") log <- log[-1]
    paste(log, collapse="\n")
}
