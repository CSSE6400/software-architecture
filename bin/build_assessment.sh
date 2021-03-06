#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${REPO_ROOT}/dist"
mkdir -p "${REPO_ROOT}/dist/assessment"

for folder in ${REPO_ROOT}/assessment/*; do
    echo $folder
    if [[ -f "${folder}/latexmkrc" && -f "${folder}/publish" ]]; then
        pushd $folder;
        latexmk -halt-on-error
        if [ $? -ne 0 ]; then
            echo "error: $(basename $folder) assignment failed to build"
            exit 1
        fi
        cp ./out/main.pdf "${REPO_ROOT}/dist/assessment/$(basename $folder).pdf"
        popd
    fi
done
