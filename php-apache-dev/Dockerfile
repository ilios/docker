FROM ilios/php-apache:latest

MAINTAINER Ilios Project Team <support@iliosproject.org>

ENV SYMFONY_ENV dev
ENV ILIOS_API_ENVIRONMENT dev
ENV ILIOS_API_DEBUG true

USER www-data
RUN /usr/bin/composer install \
  --working-dir /var/www/ilios \
  --no-progress \
  --no-suggest \
  --no-interaction \
  --optimize-autoloader

USER root
