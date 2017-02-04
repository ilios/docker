FROM ilios/source:v3.26.0

MAINTAINER Ilios Project Team <support@iliosproject.org>

ENV COMPOSER_HOME /tmp
ENV SYMFONY_ENV prod
ENV ILIOS_API_ENVIRONMENT prod
ENV ILIOS_API_DEBUG false

RUN apk add --update \
    curl \
    php7 \
    php7-fpm \
    php7-apcu \
    php7-dom \
    php7-json \
    php7-ldap \
    php7-opcache \
    php7-openssl \
    php7-pdo \
    php7-pdo_mysql \
    php7-xml \
    php7-zlib \
    php7-phar \
    php7-mbstring \
    php7-session \
    php7-ctype

RUN ln -s /usr/bin/php7 /usr/bin/php
RUN ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm
RUN rm -rf /var/cache/apk/* && rm -rf /tmp/*

ADD ilios.ini /etc/php7/fpm/conf.d/
ADD ilios.ini /etc/php7/cli/conf.d/
ADD php-fpm.conf /etc/php7/
ADD parameters.yml-default /var/www/ilios/app/config/parameters.yml
RUN chown nobody /var/www/ilios/app/config/parameters.yml

VOLUME /data
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
USER nobody
RUN /usr/local/bin/composer install \
  --working-dir /var/www/ilios \
  --prefer-dist \
  --no-dev \
  --no-progress \
  --no-suggest \
  --optimize-autoloader

USER root
CMD ["php-fpm", "-F"]

EXPOSE 9000
