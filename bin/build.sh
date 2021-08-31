#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${REPO_ROOT}/dist"
mkdir -p "${REPO_ROOT}/dist/handouts"
mkdir -p "${REPO_ROOT}/dist/slides"


pandoc "${REPO_ROOT}/cases/"*.md -o "${REPO_ROOT}/dist/SoftwareArchitectureCases.pdf"

CONTENT="architectures.layered,LayeredArchitecture qualities,QualityAttributes"

for i in ${CONTENT}; do IFS=","; set -- $i;
    # python3 -m presentations $1
    # cp "${REPO_ROOT}/workdir/$1/slides.pdf" "${REPO_ROOT}/dist/slides/$2.pdf"
    # cp -r "${REPO_ROOT}/workdir/images" "${REPO_ROOT}"

    notes="${1//.//}.md"
    pandoc "${REPO_ROOT}/notes/${notes}" \
        -o "${REPO_ROOT}/dist/handouts/$2.pdf" \
        --bibliography ${REPO_ROOT}/references/books.bib \
        --bibliography ${REPO_ROOT}/references/articles.bib \
        --csl ${REPO_ROOT}/references/style.csl
done
# pandoc "${REPO_ROOT}/notes/architectures/layered.md" -o "${REPO_ROOT}/dist/handouts/LayeredArchitecture.pdf"

# python3 -m presentations layered
# cp "${REPO_ROOT}/workdir/layered/slides.pdf" "${REPO_ROOT}/workdir/slides/LayeredArchitecture.pdf"