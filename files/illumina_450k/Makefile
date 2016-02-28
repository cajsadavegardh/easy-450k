all: Temp/dataset_loaded.RData Temp/preprocessed_dataset.RData

Temp/dataset_loaded.RData: RawData/input_file.txt Scripts/loading.R
		Rscript --no-save --no-restore --verbose Scripts/loading.R

Temp/preprocessed_dataset.RData: Temp/dataset_loaded.RData Configs/config.yaml Scripts/preprocessing.R
		Rscript --no-save --no-restore --verbose Scripts/preprocessing.R
