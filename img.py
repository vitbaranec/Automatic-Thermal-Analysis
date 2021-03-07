#!/usr/bin/python3

## USAGE: 
## pip3 install pandas rpy2

import os
import sys
import csv
import pandas as pd
import rpy2.robjects as robjects

from rpy2.robjects.packages import importr

DATA_DIR = "source_images/"
R_LIB_DIR = "r_libs/"
R_DL_DIR = "r_downloads/"
R_CSV_EXPORT_DIR = "r_csv_export/" # used in img.R
CLEAN_CSV_EXPORT_DIR = "clean_csv_export/"

if not os.path.exists(DATA_DIR):
        os.makedirs(DATA_DIR)

if not os.path.exists(R_LIB_DIR):
        os.makedirs(R_LIB_DIR)

if not os.path.exists(R_DL_DIR):
    os.makedirs(R_DL_DIR)

if not os.path.exists(R_CSV_EXPORT_DIR):
    os.makedirs(R_CSV_EXPORT_DIR)

if not os.path.exists(CLEAN_CSV_EXPORT_DIR):
    os.makedirs(CLEAN_CSV_EXPORT_DIR)

importr('png', lib_loc=R_LIB_DIR)
importr('tiff', lib_loc=R_LIB_DIR)
importr('Thermimage', lib_loc=R_LIB_DIR)

## TODO: zkontrolovat at se neinstaluje furt dokola (check if exists)
#utils = importr('utils')
#utils.install_packages('png', lib=R_LIB_DIR, destdir=R_DL_DIR)
#utils.install_packages('tiff', lib=R_LIB_DIR, destdir=R_DL_DIR)
#utils.install_packages('Thermimage', repos='http://cran.us.r-project.org', lib=R_LIB_DIR, destdir=R_DL_DIR)

r_context = robjects.r

images_to_process = os.listdir(DATA_DIR)

for image in images_to_process:
    file_name = os.path.splitext(image)[0]
    r_context.assign('in_img_file_name', os.path.abspath(DATA_DIR + file_name + ".jpg"))
    r_context.assign('out_csv_filename', os.path.abspath(R_CSV_EXPORT_DIR + file_name + ".csv"))
    r_context.source('img.R')

csv_to_process = os.listdir(R_CSV_EXPORT_DIR)

for csv_file in csv_to_process:
    data = pd.read_csv(R_CSV_EXPORT_DIR + csv_file)
    array = data.values # list of rows

    rows = len(array)
    cols = len(array[0])

    THRESHOLD = 100

    final_data = [[0 for x in range(cols)] for y in range(rows)] 
    for rowIndex in range(rows):
        if(rowIndex == 0):
            continue
        row = array[rowIndex]
        for colIndex in range(cols):
            if(colIndex == 0):
                continue
            col = row[colIndex]

            if(col >= THRESHOLD):
                final_data[rowIndex][colIndex] = col

    with open(CLEAN_CSV_EXPORT_DIR + csv_file, 'w+', newline='') as file:
        csvWriter = csv.writer(file, delimiter=',')
        csvWriter.writerows(final_data)

