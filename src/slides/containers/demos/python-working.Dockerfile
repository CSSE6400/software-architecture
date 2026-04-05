FROM python:3.7

RUN pip install numpy

WORKDIR /home/brae/csse6400
RUN echo 'export PS1="my-pc> "' >> /root/.bashrc

COPY program.py .

CMD ["/bin/bash"]
