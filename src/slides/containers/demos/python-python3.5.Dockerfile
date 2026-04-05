FROM python:3.5

WORKDIR /home/richard/csse6400
RUN echo 'export PS1="richards pc (with python)> "' >> /root/.bashrc

COPY program.py .

CMD ["/bin/bash"]
