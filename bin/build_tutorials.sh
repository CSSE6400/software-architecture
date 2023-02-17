#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

DIST_DIR="${REPO_ROOT}/dist/tutorials"
mkdir -p "${REPO_ROOT}/dist"
mkdir -p "${DIST_DIR}"

for folder in ${REPO_ROOT}/tutorials/*; do
    echo $folder
    if [[ -f "${folder}/latexmkrc" ]]; then
        pushd $folder;
        # Build PDFs
        latexmk -halt-on-error
        if [ $? -ne 0 ]; then
            echo "error: $(basename $folder) tutorial failed to build"
            exit 1
        fi
        cp ./out/main.pdf "${DIST_DIR}/$(basename $folder).pdf"

        # Build HTML
        latexmk -pdf- -dvi -outdir= -halt-on-error
        if [ $? -ne 0 ]; then
            echo "error: $(basename $folder) notes failed to build"
        #    exit 1
        else
            HTML_DIR="${DIST_DIR}/$(basename $folder)"
            mkdir -p "${HTML_DIR}"
            cp ./main.html "${HTML_DIR}/index.html"
            cp ./main.css ./*.svg ./*.png "${HTML_DIR}"
            cp -r ./images ./diagrams "${HTML_DIR}"
        fi
        popd
    fi
done
