FROM ubuntu:16.04

RUN apt-get update -qq \
    && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /opt/ants-2.3.4
RUN curl -fsSL https://bit.ly/ants234 | tar -xz -C /opt/ants-2.3.4 --strip-components 1
ENV PATH=/opt/ants-2.3.4:$PATH
ENV ANTSPATH=/opt/ants-2.3.4
