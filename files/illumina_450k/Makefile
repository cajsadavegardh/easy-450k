all: Output/knitr_report.html

Output/knitr_report.html: Temp/bmiq_dataset.RData Temp/preprocessed_dataset.RData Temp/dataset_loaded.RData Temp/combat_results.RData Results/analyzed_dataset.RData
		Rscript --no-save --no-restore --verbose Scripts/generate_knitr_report.R

Temp/dataset_loaded.RData: RawData/input_file.txt Scripts/loading.R
		Rscript --no-save --no-restore --verbose Scripts/loading.R

Temp/preprocessed_dataset.RData: Temp/dataset_loaded.RData Configs/probe_filtering.yaml Configs/sample_filtering.yaml Configs/normalization.yaml Scripts/preprocessing.R
		Rscript --no-save --no-restore --verbose Scripts/preprocessing.R

Temp/bmiq_dataset.RData: Temp/preprocessed_dataset.RData Configs/bmiq.yaml Scripts/bmiq.R
		Rscript --no-save --no-restore --verbose Scripts/bmiq.R

Temp/combat_results.RData: Temp/bmiq_dataset.RData Scripts/combat.R
		Rscript --no-save --no-restore --verbose Scripts/combat.R

Results/analyzed_dataset.RData: Temp/combat_results.RData Configs/analysis.yaml Scripts/analysis.R
		Rscript --no-save --no-restore --verbose Scripts/analysis.R
