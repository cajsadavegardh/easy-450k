# Easy-450k

This program creates prepared projects to analyze Illumina 450k array DNA methylation data 
by changing a bunch of config files without using extensive programming.


It will do the following for you:

- Create a project structure
- Create a set of R scripts that will be able run the whole pipeline, from reading the data to 
running statistical routines, using GNU Make
- Generate a report with QC plots and project statistics

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

For more info, please read this guide (here will be the guide).

### Dependencies ###

python3 (Works with python3 only)
PyYaml

### Installation ###

git clone https://github.com/petr-volkov/project-templates

### Usage ###

1. Create a new project
        
        python3 ${path_to_cloned_repo}/python_templates.py new-450k-project illumina-450k
        
2. Edit configuration files

3. Copy or link your GenomeStudio output file to RawData/input_file.txt

4. Run 'make' in the project dir.

#### Illumina 450k configuration options ####

###### 1. Configs/analysis_samples.txt
Includes a list of samples, line by line, to be included in the analysis.

###### 2. Configs/probe_filtering.yaml
Allows to define criteria to filter probes from the analysis.

To set up filtering steps, put the required parameters in a .yaml file like this

    filtering:
        mean_detection: 0.01
        rs_probes : true
        ch_probes : true
        snp_targets: 0.1
        cross_reactive: 49
        x_chr: true
        y_chr: false

***filtering:*** - denotes filtering section of the config
***mean_detection: 0.01*** - removes probes with mean Illumina detection pvalue > 0.01  
***rs_probes : true*** - removes probes with mean Illumina detection pvalue > 0.01  
***ch_probes : true*** - removes Illumina non-CpG 'ch' probes  
***snp_targets: 0.1*** - Remove probes with SNPs in a target CpG with dbSNP MAF at least 0.1 !!!! USE WITH CAUTION - LEGACY MODE - NOT FULLY IMPLEMENTED !!!!  
***cross_reactive: 49*** - Removes probes that cross-hybridize to different genomic location with at least 49 probes (possible values - 47, 48, 49, 50).  
***x_chr: true*** - Remove x chromosome probes  
***y_chr: false*** - Remove y chromosome probes


###### 3. Configs/normalization.yaml
Allows to define criteria to normalize dataset
Example:

	background_correct: true
    adjust_color_bias: false
	quantile_normalize: true

###### 4. Configs/bmiq.yaml
Allows to define criteria to perform BMIQ color bias adjustment

Available options:

	seed: 100
	nfit: 50000
	n_cores: 30

seed - random generator seed, so that the BMIQ results are reproducible
nfit - Number of probes of a given design to use for the fitting. 
n_cores - how many parallel processess will be used to run bmiq

You can additionally set any other parameters of BMIQ function.

###### 5. Configs/combat.yaml
Allows to define criteria to perform Combat batch correction




        
