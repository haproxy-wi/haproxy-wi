FROM tiangolo/uwsgi-nginx:python3.8

ENV UWSGI_INI /var/www/haproxy-wi/uwsgi.ini

RUN apt-get update && \
	apt-get install git net-tools lshw dos2unix apache2 python3-pip g++ freetype2-demos libatlas-base-dev apache2-ssl-dev netcat python3 python3-ldap libpq-dev python-dev libpython-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libffi-dev python3-dev libssl-dev gcc rsync ansible libpng-dev libqhull-dev libfreetype6-dev libagg-dev pkg-config -y

WORKDIR /var/www/haproxy-wi/

RUN git clone https://github.com/Aidaho12/haproxy-wi.git .

RUN chown -R nginx:nginx /var/www/haproxy-wi

RUN pip3 install -r requirements.txt

RUN chmod +x /var/www/haproxy-wi/app/*.py 
RUN cp haproxy-wi/config_other/logrotate/* /etc/logrotate.d/
RUN cp haproxy-wi/config_other/syslog/* /etc/rsyslog.d/
RUN systemctl daemon-reload && systemctl restart rsyslog

RUN mkdir /var/www/haproxy-wi/app/certs /var/www/haproxy-wi/keys /var/www/haproxy-wi/configs/ /var/www/haproxy-wi/configs/hap_config/ /var/www/haproxy-wi/configs/kp_config/ /var/www/haproxy-wi/configs/nginx_config/ /var/www/haproxy-wi/log/

WORKDIR /var/www/haproxy-wi/app

RUN create_db.py

#RUN chmod +x /var/www/haproxy-wi/app/tools/*.py && chmod +x /var/www/haproxy-wi/app/*.py && mkdir /var/www/haproxy-wi/keys /var/www/haproxy-wi/configs /var/www/haproxy-wi/configs/hap_config/ /var/www/haproxy-wi/configs/kp_config/ /var/www/haproxy-wi/log/ && \
#	/var/www/haproxy-wi/app/create_db.py

COPY supervisord.conf /etc/supervisor/conf.d/additional.conf
COPY nginx.conf /app/nginx.conf
COPY uwsgi.ini /var/www/haproxy-wi/uwsgi.ini

RUN chown -R nginx:nginx /var/www/haproxy-wi

WORKDIR /var/www/haproxy-wi/

