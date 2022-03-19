#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${REPO_ROOT}/dist"
mkdir -p "${REPO_ROOT}/dist/slides"

for folder in ${REPO_ROOT}/slides/*; do
    echo $folder
    if [[ -f "${folder}/latexmkrc" ]]; then
        pushd $folder;
        latexmk -halt-on-error
        if [ $? -ne 0 ]; then
            echo "error: $(basename $folder) slides failed to build"
            exit 1
        fi
        cp ./out/main.pdf "${REPO_ROOT}/dist/slides/$(basename $folder).pdf"
        # Cleanup build artifacts
        latexmk -c
        # Build presenter version with flags enabled
        latexmk -halt-on-error -usepretex 
        if [ $? -ne 0 ]; then
            echo "error: $(basename $folder) slides failed to build presenter version"
            exit 1
        fi
        cp ./out/main.pdf "${REPO_ROOT}/dist/slides/$(basename $folder)-presenter.pdf"
        popd
    fi
done
