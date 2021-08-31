#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${REPO_ROOT}/dist"
mkdir -p "${REPO_ROOT}/dist/handouts"

pandoc "${REPO_ROOT}/cases/"*.md -o "${REPO_ROOT}/dist/SoftwareArchitectureCases.pdf"

. "${REPO_ROOT}/bin/_content.sh"

for i in ${CONTENT}; do IFS=","; set -- $i;
    notes="${1//.//}.md"
    pandoc "${REPO_ROOT}/notes/${notes}" \
        -o "${REPO_ROOT}/dist/handouts/$2.pdf" \
        --bibliography ${REPO_ROOT}/references/books.bib \
        --bibliography ${REPO_ROOT}/references/articles.bib \
        --csl ${REPO_ROOT}/references/style.csl
done
