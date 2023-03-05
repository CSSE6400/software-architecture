FROM ubuntu:latest

WORKDIR /home/brae/csse6400
RUN echo 'export PS1="> "' >> /root/.bashrc

#RUN mount -t tmpfs tmpfs /home/brae/csse6400
RUN mkdir lower merged tmp tmp/upper tmp/workdir
RUN echo "password1234" >> lower/passwords.txt
RUN touch lower/help.me tmp/upper/diary.md
#RUN mount -t tmpfs tmpfs upper && mount -t tmpfs tmpfs workdir
#RUN mount -t overlay -o lowerdir=lower/,upperdir=upper/,workdir=workdir none merged
COPY layers.sh /bin/layers.sh

CMD ["/bin/layers.sh"]
