#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

mkdir -p "${REPO_ROOT}/dist"
mkdir -p "${REPO_ROOT}/dist/assessment"

build_assignment() {
    local folder="$1"
    local output_name="$2"

    echo "$folder"
    pushd "$folder" >/dev/null || return 1
    latexmk -halt-on-error
    if [ $? -ne 0 ]; then
        echo "error: ${output_name} assignment failed to build"
        popd >/dev/null || true
        exit 1
    fi
    cp ./out/main.pdf "${REPO_ROOT}/dist/assessment/${output_name}.pdf"
    popd >/dev/null || return 1
}

for folder in ${REPO_ROOT}/assessment/*; do
    if [[ -f "${folder}/latexmkrc" && -f "${folder}/publish" ]]; then
        build_assignment "${folder}" "$(basename "${folder}")"
    fi
done

for folder in ${REPO_ROOT}/assessment/project/project-descriptions/*; do
    if [[ -f "${folder}/latexmkrc" && -f "${folder}/main.tex" && -f "${folder}/publish" ]]; then
        build_assignment "${folder}" "project-$(basename "${folder}")"
    fi
done
