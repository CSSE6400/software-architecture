#!/bin/bash
# Enter the pandoc docker container to debug dependency issues

REPO_ROOT=$(git rev-parse --show-toplevel)

docker run -it --rm -v ${REPO_ROOT}:/workdir --entrypoint bash --workdir /workdir braewebb/pandoc
