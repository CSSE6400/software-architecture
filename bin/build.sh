#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${REPO_ROOT}/dist"

pandoc "${REPO_ROOT}/cases/"*.md -o "${REPO_ROOT}/dist/SoftwareArchitectureCases.pdf"
