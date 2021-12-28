#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${REPO_ROOT}/dist"
mkdir -p "${REPO_ROOT}/dist/handouts"

for folder in ${REPO_ROOT}/notes/*; do
    echo $folder
    if [[ -f "${folder}/latexmkrc" ]]; then
        pushd $folder;
        latexmk
        cp ./out/main.pdf "${REPO_ROOT}/dist/handouts/$(basename $folder).pdf"
        popd
    fi
done

pushd ${REPO_ROOT}/notes
latexmk
cp ./out/notes.pdf "${REPO_ROOT}/dist/handouts/notes.pdf"
popd
