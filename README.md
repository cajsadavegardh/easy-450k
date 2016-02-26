# project-templates

This project is an automated pipeline creator for various project types.
It's goal is for a user to delegate repetitive tasks of initiating a new project to the Program.
It is (will) be able to create a project structure, a set of scripts, and a Makefile.
This scripts will perform common analysis tasks like preprocessing, normalizing and analyzing all sorts of bioinformatic data by simply calling the Makefile.

### Design idea ###

Each project template will have a template file (f.e. templates/illumina_450k.tmpl) and a dedicated folder (f.e. files/illumina_450k).
Each folder and template for the same project should have the same name.

### Dependencies ###

Works with python3 only.

### Installation ###

Just clone the current repo.

### Usage ###

        python3 python_templates.py ${project-name} ${template-name}
        
For example:

        python3 python_templates.py new-450k-project illumina-450k
        
### Plans ###

- Project templates for the following project types:

    - Illumina 450k array analysis
    - methylation QTL
    - DMR-based WGBS analysis
    - RNA-seq analysis


- Plots and report generation for project types.