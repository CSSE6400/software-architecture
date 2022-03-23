FROM fedora:latest

RUN yum install -y httpd

RUN yum install -y git
RUN cd /var/www/html && git clone https://github.com/Hextris/hextris .

EXPOSE 80

CMD [ "httpd", "-D", "FOREGROUND" ]
