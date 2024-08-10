# Load necessary libraries
library(rgbif)
library(dplyr)
library(readr)

# Create a function to convert the data to GBIF compatible format
convert_to_gbif <- function(file_path, species_name) {
  # Read the data from the file
  data <- read_tsv(file_path)
  gbif_data <- data %>%
    select(id = id,
           latitude = latitude,
           longitude = longitude,
           year = year_of_sampling_from,  # Assuming we are using the starting year
           abundance = abundances) %>%
    mutate(scientificName = species_name,  # Add the new column with the constant value
           eventDate = as.Date(paste(year, "01-01", sep = "-")),
           basisOfRecord = "MaterialSample",
           occurrenceStatus = "present",
           datasetName = paste0(gsub(" ", "_", species_name), "_study"),  # Create datasetName based on species name
           institutionCode = "GBIF") %>%
    select(id, scientificName, latitude, longitude, eventDate, basisOfRecord, occurrenceStatus, datasetName, institutionCode, abundance)
  
  return(gbif_data)
}

############################
# creation of GBIF objects #
############################

# Define the file path
setwd("C:/LAB/GlobalFungi_to_GBIF2")

gbif_data1 <- convert_to_gbif("Russula_bicolor.txt", "Russula bicolor")
gbif_data2 <- convert_to_gbif("Amanita.txt", "Amanita")

# View the GBIF formatted data
head(gbif_data1)
head(gbif_data2)

# Optionally, save the converted data to a new file
write_csv(gbif_data1, "Russula_bicolor_gbif_format.csv")
write_csv(gbif_data2, "Amanita_gbif_format.csv")

