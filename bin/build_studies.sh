#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

DIST_DIR="${REPO_ROOT}/dist/studies"
mkdir -p "${REPO_ROOT}/dist"
mkdir -p "${DIST_DIR}"

for folder in ${REPO_ROOT}/studies/*; do
    echo $folder
    if [[ -f "${folder}/latexmkrc" ]]; then
        pushd $folder;
        # Build PDFs
        latexmk -halt-on-error
        if [ $? -ne 0 ]; then
            echo "error: $(basename $folder) case study failed to build as PDF"
            exit 1
        fi
        cp ./out/main.pdf "${DIST_DIR}/$(basename $folder).pdf"
		# If the writeup of the sample solution exists, copy it as well.
		if [ -f ./out/writeup.pdf ]; then
			cp ./out/writeup.pdf "${DIST_DIR}/$(basename $folder)-writeup.pdf"
		fi

        # Build HTML
        latexmk -pdf- -dvi -outdir= -halt-on-error
        if [ $? -ne 0 ]; then
            echo "error: $(basename $folder) case study failed to build as HTML"
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
