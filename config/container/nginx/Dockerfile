FROM nginx:1.7.1

ADD nginx.conf /etc/nginx.conf

ADD start-nginx.sh /usr/bin/start-nginx
RUN chmod +x /usr/bin/start-nginx

CMD /bin/bash /usr/bin/start-nginx
