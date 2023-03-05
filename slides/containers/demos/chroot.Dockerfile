FROM ubuntu:latest

WORKDIR /home/brae/csse6400
RUN echo 'export PS1="> "' >> /root/.bashrc
RUN mkdir slides assignment-solutions

CMD ["/bin/bash"]
