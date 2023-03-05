FROM ubuntu:latest

WORKDIR /home/richard/csse6400
RUN echo 'export PS1="richards pc> "' >> /root/.bashrc

COPY program.py .

CMD ["/bin/bash"]
