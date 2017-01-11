# Set workign directory
setwd("D:/Data Science/R-Data-Science-Study/Reproducible Research/Week 2/Peer-graded assignment")

# Set up directory and download dataset for analysis
# URL to download
fileURL <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"

# Local data filename
dataFileZIP <- "./repdata_data_activity.zip"

# Directory for the dataset
dirFile <- "./"

# If not exist, download the dataset.zip,
if (file.exists(dataFileZIP) == FALSE) {
      download.file(fileURL, destfile = dataFileZIP)
}

# Uncompress data file
if (file.exists(dirFile) == FALSE) {
      unzip(dataFileZIP)
}


