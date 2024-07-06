#!/bin/bash

# Define the base URL
BASE_URL="https://nex-gddp-cmip6.s3-us-west-2.amazonaws.com/NEX-GDDP-CMIP6/BCC-CSM2-MR/historical/r1i1p1f1/pr/"

# Loop through the years from 1985 to 2014
for year in {1985..2014}; do
    # Define the file name for the current year
    FILE_NAME="pr_day_BCC-CSM2-MR_historical_r1i1p1f1_gn_${year}.nc"

    # Construct the full URL for the current year's file
    DOWNLOAD_URL="${BASE_URL}${FILE_NAME}"

    # Download the file
    echo "Downloading ${FILE_NAME}..."
    wget "$DOWNLOAD_URL"

    # Check if download was successful
    if [ $? -eq 0 ]; then
        echo "${FILE_NAME} downloaded successfully."
    else
        echo "Error downloading ${FILE_NAME}."
    fi
done
