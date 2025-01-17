#!/bin/bash
#
# Copyright (C) 2020 The LineageOS Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

MOKEE_ROOT="${MY_DIR}/../../.."

HELPER="${MOKEE_ROOT}/vendor/lineage/build/tools/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

SRC=$1
SRC_QC=$2

# Initialize the helper
setup_vendor "${DEVICE_COMMON}" "${VENDOR}" "${MOKEE_ROOT}" true "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}"
extract "${MY_DIR}/proprietary-files-qc.txt" "${SRC_QC}"

if [ -f "${MY_DIR}/../${DEVICE}/proprietary-files.txt" ]; then
    # Reinitialize the helper for device
    setup_vendor "${DEVICE}" "${VENDOR}" "${MOKEE_ROOT}" false "${CLEAN_VENDOR}"

    extract "${MY_DIR}/../${DEVICE}/proprietary-files.txt" "${SRC}"
fi

"${MY_DIR}/setup-makefiles.sh"

BLOB_ROOT="${MOKEE_ROOT}/vendor/${VENDOR}/${DEVICE_COMMON}/proprietary"
