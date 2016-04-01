
#analyze_dataset  <- function(meth_dataset, type=c("lm", "wilcoxon"), n_cores=1, perform_fdr=T, ...) {
#    meth_matrix <- get_values(meth_dataset)
#    if(type == "lm") {
#        run_lm(meth_matrix, n_cores=1, perform_fdr=T, ...)
#    } else if(type == "wilcoxon") {
#        run_wilcoxon(meth_matrix, n_cores=1, perform_fdr=T, ...)
#    }
#}

run_wilcoxon <- function(meth_dataset, n_cores=1, perform_fdr=T, group, paired=F, exact=F, correct=T) {
    stopifnot(ncol(meth_dataset) == length(group)) #basic check

    meth_matrix <- get_values(meth_dataset)
    func <- .make_wilcoxon_analysis_func(group, paired, exact, correct)
    stats <- chunk_apply(meth_matrix, func, n_cores)

    fdr <- foreach(pval_column=iter(as.data.frame(stats[, grepl("pvals", colnames(stats))])), .combine=cbind) %dopar% {
        return(p.adjust(pval_column, method="BH"))
    }
    fdr <- as.data.frame(fdr)
    colnames(fdr) <- gsub("pvals", "fdr", grep("pvals", colnames(stats), value=T))
    meth_dataset <- set_annotation(meth_dataset, cbind(get_annotation(meth_dataset), stats, fdr))
    log <- paste("Performed wilcoxon test, found", length(which(fdr < 0.05)), "FDR < 0.05")
    MonadWriter(meth_dataset, log)
}

run_lm <- function(meth_dataset, n_cores=1, perform_fdr=T, phenotypes_table, numeric_names=NULL, categorical_names=NULL) {
    stopifnot(ncol(meth_dataset) == nrow(phenotypes_table)) #basic check

    meth_matrix <- get_values(meth_dataset)
    func <- .make_lm_analysis_func(phenotypes_table, numeric_names, categorical_names)
    stats <- chunk_apply(meth_matrix, func, n_cores)

    ## add fdr
    fdr <- foreach(pval_column=iter(stats[, grepl("pvals", colnames(stats))]), .combine=cbind) %dopar% {
        return(p.adjust(pval_column, method="BH"))
    }
    colnames(fdr) <- gsub("pvals", "fdr", grep("pvals", colnames(stats), value=T))
    meth_dataset <- set_annotation(meth_dataset, cbind(get_annotation(meth_dataset), stats, fdr))
    log <- paste("Performed linear model analysis, found", length(which(fdr < 0.05)), "FDR < 0.05")
    MonadWriter(meth_dataset, log)
}

chunk_apply <- function(matrix, func, n_cores=1) {
    if(n_cores > 1) {
        doMC::registerDoMC(n_cores)
    }

    # split the matrix into n_cores equal (except the last one) chunks
    splitted_matrix <- split(matrix, cut(seq_along(1:nrow(matrix)), n_cores, labels=F))
    foreach(chunk=iter(splitted_matrix), .combine=rbind) %dopar% {
        pvals <- apply(chunk, 1, func)
        pvals <- as.data.frame(pvals)
        if(ncol(pvals) > 1) pvals <- t(pvals)
        pvals
    }
}

.make_lm_analysis_func <- function(phenotypes_table, numeric_names=NULL, categorical_names=NULL) {
    cov_formula <- paste("outcome ~ ", paste(c(numeric_names, categorical_names), collapse=" + "))
    cov_formula <- as.formula(cov_formula)
    function(outcome) {
        fit <- lm(cov_formula, data=data.frame(phenotypes_table, outcome=outcome))
        coeffs <- summary(fit)$coefficients[-1, ]
        betas <- coeffs[, 1]
        std_errors <- coeffs[, 2]
        pvals <- coeffs[, 4]
        names(betas) <- paste(rownames(coeffs), "betas", sep="_")
        names(std_errors) <- paste(rownames(coeffs), "std_errors", sep="_")
        names(pvals) <- paste(rownames(coeffs), "pvals", sep="_")
        c(betas, std_errors, pvals)
    }
}

.make_wilcoxon_analysis_func <- function(group, paired=F, exact=F, correct=T) {
    function(outcome) {
        a <- as.numeric(outcome[group == 1])
        b <- outcome[group == 2]
        wilcox.test(a, b, paired=paired, exact=exact, correct=correct)$p.value
    }
}
