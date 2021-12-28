#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

if [ $# -eq 0 ]; then
    echo "usage: mknote.sh <note>"
    exit 1
fi

note="$1"
note_path="${REPO_ROOT}/notes/${note}"

mkdir -p "${note_path}"
cp "${REPO_ROOT}/tex/latexmkrc" "${note_path}"
cp "${REPO_ROOT}/tex/template.tex" "${note_path}/main.tex"
touch "${note_path}/content.tex"

echo "Note created: ${note_path}"
echo "Don't forget to update the title and add the note to notes/notes.tex"
