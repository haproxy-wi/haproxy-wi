FROM debian:buster

# Upgrade System
RUN apt-get update && apt-get upgrade -y

# Install needed packages for haproxy-wi
RUN apt-get install git net-tools lshw dos2unix apache2 \
    python3-pip g++ freetype2-demos libatlas-base-dev apache2-ssl-dev netcat python3 \
    python3-ldap libpq-dev python-dev libpython-dev libxml2-dev libxslt1-dev libldap2-dev \
    libsasl2-dev libffi-dev python3-dev libssl-dev gcc rsync ansible \
    libpng-dev libqhull-dev libfreetype6-dev libagg-dev pkg-config -y

# chg folder
WORKDIR /var/www/

# clone latest haproxy-wi
RUN git clone https://github.com/Aidaho12/haproxy-wi.git /var/www/haproxy-wi

# change file owner to www-data for Apache
RUN chown -R www-data:www-data haproxy-wi/

# copy Apache config file and enable needed mods
RUN cp haproxy-wi/config_other/httpd/* /etc/apache2/sites-available/

# replace httpd with apache2 in config from CentOS for Debian
RUN sed -i 's/httpd/apache2/' /etc/apache2/sites-available/haproxy-wi.conf

RUN a2ensite haproxy-wi.conf
RUN a2enmod cgid
RUN a2enmod ssl

# install python requirements
RUN pip3 install -r haproxy-wi/requirements.txt

# allow python files to be executed
RUN chmod +x haproxy-wi/app/*.py 

# copy logrotate and syslog config files
RUN cp haproxy-wi/config_other/logrotate/* /etc/logrotate.d/
RUN cp haproxy-wi/config_other/syslog/* /etc/rsyslog.d/

# reload services
RUN systemctl daemon-reload  
RUN systemctl restart apache2
RUN systemctl restart rsyslog

# create needed folders
RUN mkdir /var/www/haproxy-wi/app/certs /var/www/haproxy-wi/keys /var/www/haproxy-wi/configs/ /var/www/haproxy-wi/configs/hap_config/ /var/www/haproxy-wi/configs/kp_config/ /var/www/haproxy-wi/configs/nginx_config/ /var/www/haproxy-wi/log/

RUN chown -R www-data:www-data /var/www/haproxy-wi/

WORKDIR /var/www/haproxy-wi/app

# create database
RUN python create_db.py

RUN chown -R www-data:www-data /var/www/haproxy-wi/
