#FROM debian:buster
FROM python:3.8-slim
# Install needed packages for haproxy-wi
RUN apt-get update &&  apt-get dist-upgrade -y && apt-get install git net-tools lshw dos2unix apache2 \
    python3-pip python3-matplotlib g++ freetype2-demos libatlas-base-dev apache2-ssl-dev netcat python3 \
    python3-ldap libpq-dev python-dev libpython-dev libxml2-dev libxslt1-dev libldap2-dev \
    libsasl2-dev libffi-dev python3-dev libssl-dev gcc rsync ansible \
    libpng-dev libqhull-dev libfreetype6-dev libagg-dev pkg-config -y && \
    apt-get clean && \
    pip install --no-cache-dir matplotlib paramiko-ng configparser cython && \
    git clone https://github.com/Aidaho12/haproxy-wi.git /var/www/haproxy-wi && date && \
    cd /var/www && pip3 install -r haproxy-wi/requirements.txt && date && apt-get -y remove g++ gcc make pkg-config && apt-get -y autoremove
#FROM alpine


# chg folder
WORKDIR /var/www/


#RUN apk add cargo py3-cryptography  musl-dev libffi-dev openssl-dev openssh py-virtualenv dos2unix apache2 cython libpq py3-pip python3-dev libffi-dev py3-matplotlib libc6-compat rsync gcc git g++ freetype-dev && date

#########

# clone latest haproxy-wi
#RUN apk add git
#RUN git clone https://github.com/Aidaho12/haproxy-wi.git /var/www/haproxy-wi && date

# install python requirements
#RUN pip3 install -r haproxy-wi/requirements.txt && date


    # allow python files to be executed    # change file owner to www-data for Apache         # copy Apache config file and enable needed mods
RUN chmod +x /var/www/haproxy-wi/app/*.py && chown -R www-data:www-data /var/www/haproxy-wi/ && cp /var/www/haproxy-wi/config_other/httpd/* /etc/apache2/sites-available/

# replace httpd with apache2 in config from CentOS for anything, enable apache stuff , logrotate , syslog     # create needed folders

RUN sed -i 's/httpd/apache2/' /etc/apache2/sites-available/haproxy-wi.conf && \
    a2ensite haproxy-wi.conf && \
    a2enmod cgid && \
    a2enmod ssl && \
    mkdir -p /etc/logrotate.d/ /etc/rsyslog.d/ && cp haproxy-wi/config_other/logrotate/* /etc/logrotate.d/ && cp haproxy-wi/config_other/syslog/* /etc/rsyslog.d/ && \
    mkdir -p /var/www/haproxy-wi/app/certs /var/www/haproxy-wi/keys /var/www/haproxy-wi/configs/ /var/www/haproxy-wi/configs/hap_config/ /var/www/haproxy-wi/configs/kp_config/ /var/www/haproxy-wi/configs/nginx_config/ /var/www/haproxy-wi/log/ && \
    chown -R www-data:www-data /var/www/haproxy-wi/
    WORKDIR /var/www/haproxy-wi/app

    # create database
    RUN /bin/bash -c "cd /var/www/haproxy-wi/app && python3 create_db.py"

    RUN chown -R www-data:www-data /var/www/haproxy-wi/

### ##DAFUQ?# reload services ... really...the previuous maintainer had fun , obviously '!³¼[]¶³[]ł{[¼đħ]}' ...
###  RUN systemctl daemon-reload
###  RUN systemctl restart apache2
###  RUN systemctl restart rsyslog
