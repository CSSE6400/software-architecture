REM Docker on Windows can only map a local hard drive, not a network mapped hard drive.
REM Copy command below and run from command line. Docker doesn't copy with Windows path parameters.

docker run -v ${pwd}:/workspace --rm openapitools/openapi-generator-cli:latest generate --generator-name html2 --output /workspace/docs --input-spec /workspace/spec.yml --template-dir /workspace/docs-template
