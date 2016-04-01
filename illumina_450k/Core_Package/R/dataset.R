# Hide some imports from the user
`%as%` <- lambda.r::`%as%`
`%::%` <- lambda.r::`%::%`
NewObject <- lambda.r::NewObject
UseFunction <- lambda.r::UseFunction

# Define dataset type
Dataset(values, annotation) %as% {
    stopifnot(class(values) == "data.frame")
    stopifnot(class(annotation) == "data.frame")
    list(values=values, annotation=annotation)
}

get_annotation(dataset) %::% Dataset : data.frame
get_annotation(dataset) %as% dataset$annotation

get_values(dataset) %::% Dataset : data.frame
get_values(dataset) %as% dataset$values

set_annotation(dataset, df) %::% Dataset : data.frame : Dataset
set_annotation(dataset, df) %as% { dataset$annotation <- df; dataset }

set_values(dataset, df) %::% Dataset : data.frame : Dataset
set_values(dataset, df) %as% { dataset$values <- df; dataset }

# defines a function sampleNames on Dataset, as sampleNames is generic in Biobase
sampleNames.Dataset(Dataset) %::% Dataset : character
sampleNames.Dataset(dataset) %as% names(dataset$values)

# I don't know how to overload [ with lambda R so use S3
# (as lambda.r is a syntetic sugar for S3 for Haskell fans)
`[.Dataset` <- function(dataset, i, j) {
    Dataset(get_values(dataset)[i, j], get_annotation(dataset)[i, ])
}