FROM pandoc/ubuntu-latex:latest

RUN apt-get update && apt-get install -y git texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra
RUN apt-get install -y curl
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs