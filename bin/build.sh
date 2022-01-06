#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

"${REPO_ROOT}/bin/build_assessment.sh"
"${REPO_ROOT}/bin/build_notes.sh"
"${REPO_ROOT}/bin/build_practicals.sh"
"${REPO_ROOT}/bin/build_slides.sh"
