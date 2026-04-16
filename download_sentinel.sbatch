#!/bin/bash
#SBATCH --job-name=sentinel_download
#SBATCH --output=sentinel_download/run_%j/out
#SBATCH --error=sentinel_download/run_%j/err
#SBATCH --partition=serc
#SBATCH --time=120:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=2G
#SBATCH --mail-type=ALL

# Download Sentinel-1 imagery for thalassoica pipeline
# Prerequisites: UUIDs file exported from run_thalassoica

set -e

PROJECT_ROOT="/scratch/groups/dustinms/thalassoica-dev/thalassoica/opt/project"
CONTAINER="thalassoica"
CONTAINER_PATH="/opt/project"

UUIDS_FILE=".//intermediates/uuids/sentinel_download_uuids.parquet"
OUTPUT_DIR=".//intermediates/tiffs"


apptainer run --writable "${CONTAINER}" \
    uv run "sentinel1/download/download_images.py" \
    --uuids "${UUIDS_FILE}" \
    --output "${OUTPUT_DIR}" \
    --search-workers 32 \
    --download-workers 4
