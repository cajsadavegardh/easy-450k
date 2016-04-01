# Functional Programming helpers -------------

#Lambda.r -------------

`%as%` <- lambda.r::`%as%`
`%::%` <- lambda.r::`%::%`
NewObject <- lambda.r::NewObject
UseFunction <- lambda.r::UseFunction

MonadWriter(object, log) %as% {
    stopifnot(class(log) == "character")
    stopifnot(length(log) == 1)
    list(object, log)
}

Mbind(monad_writer, func) %as% {
    res <- func(monad_writer[[1]])
    log <- paste(monad_writer[[2]], " >>= ", res[[2]])
    MonadWriter(res[[1]], log)
}

Mreturn(object) %as% MonadWriter(object, "")

`%>>=%` <- Mbind

msin(object) %as% {
    res <- sin(object)
    log <- "Computed sin"
    MonadWriter(res, log)
}


Curry <- functional::Curry

# BioC helpers -------------
#.get_ml_annotation <- function(ml_object) Biobase::pData(Biobase::featureData(ml_object))

.get_ml_annotation <- functional::Compose(Biobase::featureData, Biobase::pData)

.get_det_pvals <- methylumi::pvals

.ml_background_correct <- lumi::lumiMethyB

.ml_color_adjust <- lumi::lumiMethyC

.ml_quantile_normalize <- Curry(lumi::lumiMethyN, method = "quantile")

.merge_df_to_annotation <- function(ml_object, annotation_df, by) {
    Biobase::pData(Biobase::featureData(ml_object)) <- merge(.get_ml_annotation(ml_object), annotation_df, by.x="TargetID", by.y=by, all.x = T)
    ml_object
}

.get_sample_names <- Biobase::sampleNames

.get_probe_types <- function(ml_object) {
    design_type <- as.character(.get_ml_annotation(ml_object)$INFINIUM_DESIGN_TYPE)
    design_type[design_type == "I"] <- 1
    design_type[design_type == "II"] <- 2
    as.numeric(design_type)
}

.get_betas <- functional::Compose(methylumi::betas, as.data.frame)

.m_to_beta <- lumi::m2beta

.beta_to_m <- lumi::beta2m

#Foreach and iterators -------------

`%dopar%` <- foreach::`%dopar%`
foreach <- foreach::foreach
iter <- iterators::iter


