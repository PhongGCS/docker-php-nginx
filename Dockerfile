FROM ubuntu:20.04

# Adapt from https://github.com/Frojd/Frojd-Bedrock/blob/master/Dockerfile

MAINTAINER ConceptualStudio
LABEL version="v1.4.2"

RUN apt-get update
RUN apt -y install software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y php7.4-fpm php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath

RUN apt-get -y install php-memcache php-xdebug php-geoip \
  && mkdir -p /var/run/php /var/log/supervisor /var/log/nginx /app

RUN apt-get -y install composer supervisor nginx mysql-client xz-utils
RUN apt-get -y install wget apt-utils mc inetutils-ping telnet nano \
  vim curl apt-transport-https language-pack-en

# wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
  chmod +x wp-cli.phar && \
  mv wp-cli.phar /usr/local/bin/wp

# Install Node & Yarn

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 10.15.1

RUN wget https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz"

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get -y install yarn

RUN npm install gulp -g


# Install configurations

COPY files/config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY files/config/nginx.conf /etc/nginx/sites-enabled/default
COPY files/config/php.ini /etc/php/7.4/fpm


# Permission hack

RUN usermod -u 1000 www-data

# Set up remote debugging for xdebug

ARG XDEBUG_REMOTE_HOST
ARG XDEBUG_IDEKEY
 RUN echo "xdebug.remote_enable=on" >> /etc/php/7.4/fpm/conf.d/20-xdebug.ini \
   && echo "xdebug.remote_autostart=off" >> /etc/php/7.4/fpm/conf.d/20-xdebug.ini \
   && echo "xdebug.remote_host="${XDEBUG_REMOTE_HOST} >> /etc/php/7.4/fpm/conf.d/20-xdebug.ini \
   && echo "xdebug.idekey="${XDEBUG_IDEKEY} >> /etc/php/7.4/fpm/conf.d/20-xdebug.ini \
   && rm /etc/php/7.4/cli/conf.d/20-xdebug.ini


# Open ports, multiple separated with space, e.g. EXPOSE 80 22 443

EXPOSE 80 443

# https://github.com/yarnpkg/yarn/issues/749
# To consider on handling yarn installation

WORKDIR /app
#COPY site/composer.json /app/composer.json
#COPY site/composer.lock /app/composer.lock
#RUN composer install
# Default command for machine
CMD supervisord

