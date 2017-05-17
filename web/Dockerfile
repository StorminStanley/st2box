FROM nginx:1.11
ADD ./st2.conf /etc/nginx/conf.d/st2.conf

ADD ./st2*.deb /tmp/
RUN dpkg -i /tmp/st2*.deb && rm -r /tmp/* && apt-get clean

RUN mkdir -p /etc/ssl/st2 && \
  openssl req -x509 -newkey rsa:2048 -keyout /etc/ssl/st2/st2.key -out /etc/ssl/st2/st2.crt -days 999 -nodes -subj "/C=US/ST=California/L=Palo Alto/O=StackStorm/OU=Information Technology/CN=$(hostname)"
