FROM ilios/php:v3.26.0

MAINTAINER Ilios Project Team <support@iliosproject.org>

ENV SYMFONY_ENV dev
ENV ILIOS_API_ENVIRONMENT dev
ENV ILIOS_API_DEBUG true

USER nobody
RUN /usr/local/bin/composer install \
  --working-dir /var/www/ilios \
  --no-progress \
  --no-suggest \
  --optimize-autoloader

USER root
