#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${REPO_ROOT}/dist"
mkdir -p "${REPO_ROOT}/dist/practicals"

for folder in ${REPO_ROOT}/practicals/*; do
    echo $folder
    if [[ -d "${folder}/images" ]]; then
        for puml in ${folder}/images/*.puml; do
            [ -f "$puml" ] || break
            java -jar "${REPO_ROOT}/bin/plantuml.jar" -png $puml
        done
    fi
    if [[ -f "${folder}/latexmkrc" ]]; then
        pushd $folder;
        latexmk -halt-on-error
        if [ $? -ne 0 ]; then
            echo "error: $(basename $folder) practical failed to build"
            exit 1
        fi
        cp ./out/main.pdf "${REPO_ROOT}/dist/practicals/$(basename $folder).pdf"
        # Cleanup build artifacts
        latexmk -c
        # Build instructor version with flags enabled
        latexmk -halt-on-error -usepretex 
        if [ $? -ne 0 ]; then
            echo "error: $(basename $folder) practical failed to build instructor version"
            exit 1
        fi
        cp ./out/main.pdf "${REPO_ROOT}/dist/practicals/$(basename $folder)-instructor.pdf"
        popd
    fi
done
