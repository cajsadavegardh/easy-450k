** Put project name here **

Main pipeline is performed by calling this scripts in the following order:

1. Scripts/R/Pipeline/load_data.R
2. Scripst/R/Pipeline/filter_data.R
3. Scripts/R/Pipeline/normalize_data.R
4. Scripts/R/Pipeline/bmiq.R
5. Scripts/R/Pipeline/combat.R
6. Scripts/R/Pipeline/analyzis.R

Call the project by running 'make' command in the project dir.