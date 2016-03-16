FROM ubuntu:trusty

RUN apt-get update \
  && apt-get install -y curl

ENV MISTRAL_VERSION 1.3.2-73

RUN curl -s https://packagecloud.io/install/repositories/StackStorm/staging-stable/script.deb.sh | sudo bash \
  && apt-get install -y st2mistral=${MISTRAL_VERSION} \
  && rm -rf /var/lib/apt/lists/*

RUN cp /etc/mistral/mistral.conf /mistral.conf.template \
  && md5sum /etc/mistral/mistral.conf > /mistral.conf.orig.md5

ADD ./docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
