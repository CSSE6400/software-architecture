#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${REPO_ROOT}/dist"
mkdir -p "${REPO_ROOT}/dist/handouts"

for folder in ${REPO_ROOT}/notes/*; do
    echo $folder
    if [[ -f "${folder}/latexmkrc" ]]; then
        pushd $folder;
        # Build PDFs
        latexmk -halt-on-error
        if [ $? -ne 0 ]; then
            echo "error: $(basename $folder) notes failed to build"
            exit 1
        fi
        cp ./out/main.pdf "${REPO_ROOT}/dist/handouts/$(basename $folder).pdf"

        # Build HTML
        latexmk -pdf- -dvi -outdir= -halt-on-error
        if [ $? -ne 0 ]; then
            echo "error: $(basename $folder) notes failed to build"
        #    exit 1
        else
            mkdir -p "${REPO_ROOT}/dist/handouts/$(basename $folder)"
            cp ./main.html "${REPO_ROOT}/dist/handouts/$(basename $folder)/index.html"
            cp ./main.css "${REPO_ROOT}/dist/handouts/$(basename $folder)/main.css"
            cp -r ./images "${REPO_ROOT}/dist/handouts/$(basename $folder)"
            cp -r ./diagrams "${REPO_ROOT}/dist/handouts/$(basename $folder)"
            cp ./*.svg "${REPO_ROOT}/dist/handouts/$(basename $folder)"
            cp ./*.png "${REPO_ROOT}/dist/handouts/$(basename $folder)"
        fi
        popd
    fi
done

pushd ${REPO_ROOT}/notes
latexmk
cp ./out/notes.pdf "${REPO_ROOT}/dist/handouts/notes.pdf"
popd
