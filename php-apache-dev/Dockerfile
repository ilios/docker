FROM ilios/php-apache:latest

MAINTAINER Ilios Project Team <support@iliosproject.org>

ENV APP_ENV dev
ENV APP_DEBUG true

USER www-data
RUN /usr/bin/composer install \
  --working-dir /var/www/ilios \
  --no-progress \
  --no-suggest \
  --no-interaction \
  --optimize-autoloader

USER root
