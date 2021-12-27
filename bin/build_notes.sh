#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${REPO_ROOT}/dist"
mkdir -p "${REPO_ROOT}/dist/handouts"

. "${REPO_ROOT}/bin/_content.sh"

for i in ${CONTENT}; do IFS=","; set -- $i;
    notes="${1//.//}.md"
    pandoc "${REPO_ROOT}/notes/${notes}" \
        -o "${REPO_ROOT}/dist/handouts/$2.pdf" \
        --bibliography ${REPO_ROOT}/references/books.bib \
        --bibliography ${REPO_ROOT}/references/articles.bib \
        --csl ${REPO_ROOT}/references/style.csl
done


for folder in ${REPO_ROOT}/notes/*; do
    echo $folder
    if [[ -f "${folder}/latexmkrc" ]]; then
        pushd $folder;
        latexmk
        cp ./out/main.pdf "${REPO_ROOT}/dist/handouts/$(basename $folder).pdf"
        popd
    fi
done