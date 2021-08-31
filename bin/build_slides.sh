#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${REPO_ROOT}/dist"
mkdir -p "${REPO_ROOT}/dist/slides"

. "${REPO_ROOT}/bin/_content.sh"

for i in ${CONTENT}; do IFS=","; set -- $i;
    python3 -m presentations $1
    cp "${REPO_ROOT}/workdir/$1/slides.pdf" "${REPO_ROOT}/dist/slides/$2.pdf"
    cp -r "${REPO_ROOT}/workdir/images" "${REPO_ROOT}"
done
