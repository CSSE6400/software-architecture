#!/bin/bash

docker run -v $(pwd):/workspace --rm \
    openapitools/openapi-generator-cli:latest generate \
    --generator-name k6 \
    --output /workspace/k6 \
    --input-spec /workspace/spec.yml \
