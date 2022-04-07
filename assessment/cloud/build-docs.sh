#!/bin/bash

docker run -v $(pwd):/workspace--rm \
    openapitools/openapi-generator-cli:latest generate \
    --generator-name html2 \
    --output /workspace/docs \
    --input-spec /workspace/spec.yml
