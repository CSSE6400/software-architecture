#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

"${REPO_ROOT}/bin/build_assessment.sh"
if [ $? -ne 0 ]; then
    echo "error: assessments failed to build"
    exit 1
fi
"${REPO_ROOT}/bin/build_notes.sh"
if [ $? -ne 0 ]; then
    echo "error: notes failed to build"
    exit 1
fi
"${REPO_ROOT}/bin/build_practicals.sh"
if [ $? -ne 0 ]; then
    echo "error: practicals failed to build"
    exit 1
fi
"${REPO_ROOT}/bin/build_slides.sh"
if [ $? -ne 0 ]; then
    echo "error: slides failed to build"
    exit 1
fi
