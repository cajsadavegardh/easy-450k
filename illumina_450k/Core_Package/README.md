# easy-450k.core #
A set of functions to use in Illumina 450k array analysis pipelines.


### Installation ###

##### Dependencies #####

This package is a wrapper around "lumi" and it's child, "methylumi" package from bioconductor.
Therefore, users should be aware that 

##### To install the package, follow this steps: #####

    devtools::install_github("petr-volkov/easy-450k.core")
    
##### Usage #####

In general, this functions are supposed to be used by a package named [easy-450k](https://github.com/petr-volkov/easy-450k).
It will generate a whole project structure, including default versions of this functions based on some configuration parameters.
However, this functions can also be used as an independent library.

Available pipeline steps are:

1. Reading GenomeStudio output
2. Filtering samples for consecutive analysis
3. Filtering probes based on various criteria
4. Background correction
5. Color bias adjustment
6. Quantile normalization
6. Probe bias correction
6. [BMIQ](http://www.ncbi.nlm.nih.gov/pubmed/23175756) 
7. [Batch correction](http://www.ncbi.nlm.nih.gov/pubmed/16632515)
8. Statistical analysis (linear regression or Mann-Whitney-Wilcoxon test)
