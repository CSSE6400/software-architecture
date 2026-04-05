FROM python:3.6

WORKDIR /home/richard/csse6400
RUN echo 'export PS1="richards pc (with python 3.6)> "' >> /root/.bashrc

COPY program.py .

CMD ["/bin/bash"]
