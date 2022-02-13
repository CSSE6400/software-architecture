yum install httpd
systemctl enable httpd
systemctl start httpd

yum install git
cd /var/www/html
git clone https://github.com/Hextris/hextris .
