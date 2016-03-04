# project-templates

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

###### 3. Configs/normalization.yaml
Allows to define criteria to normalize dataset

###### 4. Configs/bmiq.yaml
Allows to define criteria to perform BMIQ color bias adjustment

###### 5. Configs/combat.yaml
Allows to define criteria to perform Combat batch correction




        
