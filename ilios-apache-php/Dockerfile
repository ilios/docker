# This is the official Ilios ilios-php-apache Dockerfile which will build out an Ilios application server running on
# Apache httpd 2.4.x and PHP. It relies upon Docker images from the official PHP repository at Docker Hub at
# and will install the latest versions of PHP and Ilios by default. These versions can be overridden at build time by
# specifying the respective versions as argument on the command line, like so:
#
# docker build --build-arg "PHP_DOCKER_IMAGE=7.1.13-apache" --build-arg "ILIOS_VERSION_TAG=v3.42.0" -t ilios-apache-php .

# Initialize the arguments with a default value. These may be overridden at build time as shown in the example above.
ARG PHP_DOCKER_IMAGE=apache

# Begin with the official Composer image and name it 'composer' for reference
FROM composer AS composer

# then get the official Git image to checkout the code
FROM alpine/git AS git
ARG ILIOS_VERSION_TAG=master

# map the /tmp volume to store the Ilios source files for copying
VOLUME /tmp:/tmp

# set the ilios version tag from the CLI or default arguments
ENV ILIOS_VERSION_TAG=${ILIOS_VERSION_TAG}

# create the 'ilios' directory in /tmp and checkout the Ilios code without git history
WORKDIR /tmp/ilios
RUN git clone https://git@github.com/ilios/ilios.git --branch $ILIOS_VERSION_TAG --depth 1 /tmp/ilios

# get the proper 'PHP' image from the official PHP repo at
FROM php:$PHP_DOCKER_IMAGE
ARG ILIOS_APP_FQDN=localhost

# set the fqdn of the ilios hostname for use in SSL self-signed cert-creation and where needed
ENV ILIOS_APP_FQDN=${ILIOS_APP_FQDN}

# Now that all the 'FROM' values are set, set the maintainer
MAINTAINER Ilios Project Team <support@iliosproject.org>

# create the application root for the final container image
WORKDIR /var/www/ilios
# get the code we just cloned from git
COPY --from=git /tmp/ilios /var/www/ilios

# copy the Composer PHAR from the Composer image into the apache-php image
COPY --from=composer /usr/bin/composer /usr/bin/composer

# get/install all the PHP extensions required for Ilios and delete the source
# files after install
RUN apt-get update \
    && apt-get install -y \
    && apt-get install libldap2-dev -y \
    && apt-get install zlib1g-dev \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_mysql \
    && mv /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled/ \
    && mv /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/ \
    && mv /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ \
    && mv /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/ \
    && rm -rf /var/lib/apt/lists/* \
    && pecl channel-update pecl.php.net \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/ilios-ssl.conf \
    && mv /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/ilios.conf \
    && mv /etc/apache2/conf-available/docker-php.conf /etc/apache2/conf-enabled/ \
    # create a self-signed certificate
    && openssl req -subj "/CN=$ILIOS_APP_FQDN" -new -newkey rsa:2048 -days 365 -nodes -x509 \
        -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.pem \
    # allow httpd overrides in the /var/www/ilios/web directory
    && sed -i -e 's|/var/www|/var/www/ilios/web|g' /etc/apache2/conf-enabled/docker-php.conf \
    # update the DocumentRoot to point to the '/var/www/ilios/web' directory for http AND https
    && sed -i -e 's|/var/www/html|/var/www/ilios/web|g' /etc/apache2/sites-enabled/ilios.conf /etc/apache2/sites-enabled/ilios-ssl.conf \
    && sed -i -e 's|ssl-cert-snakeoil|localhost|g' /etc/apache2/sites-enabled/ilios-ssl.conf

# create the volume that will store the learning materials
VOLUME /data

# set all of the necessary environment variables
ENV COMPOSER_HOME=/tmp \
  SYMFONY_ENV=prod \
  ILIOS_API_ENVIRONMENT=prod \
  ILIOS_API_DEBUG=false \
  ILIOS_DATABASE_DRIVER=pdo_mysql \
  ILIOS_DATABASE_HOST=db \
  ILIOS_DATABASE_PORT=~ \
  ILIOS_DATABASE_NAME=ilios \
  ILIOS_DATABASE_USER=ilios \
  ILIOS_DATABASE_PASSWORD=ilios \
  ILIOS_DATABASE_MYSQL_VERSION=5.7 \
  ILIOS_MAILER_TRANSPORT=smtp \
  ILIOS_MAILER_HOST=127.0.0.1 \
  ILIOS_MAILER_USER=~ \
  ILIOS_MAILER_PASSWORD=~ \
  ILIOS_LOCALE=en \
  ILIOS_SECRET=ThisTokenIsNotSoSecretChangeIt \
  ILIOS_AUTHENTICATION_TYPE=form \
  ILIOS_LEGACY_PASSWORD_SALT=null \
  ILIOS_FILE_SYSTEM_STORAGE_PATH=/data \
  ILIOS_INSTITUTION_DOMAIN=example.com \
  ILIOS_SUPPORTING_LINK=null \
  ILIOS_LDAP_AUTHENTICATION_HOST=null \
  ILIOS_LDAP_AUTHENTICATION_PORT=null \
  ILIOS_LDAP_AUTHENTICATION_BIND_TEMPLATE=null \
  ILIOS_LDAP_DIRECTORY_URL=null \
  ILIOS_LDAP_DIRECTORY_USER=null \
  ILIOS_LDAP_DIRECTORY_PASSWORD=null \
  ILIOS_LDAP_DIRECTORY_SEARCH_BASE=null \
  ILIOS_LDAP_DIRECTORY_CAMPUS_ID_PROPERTY=null \
  ILIOS_LDAP_DIRECTORY_USERNAME_PROPERTY=null \
  ILIOS_SHIBBOLETH_AUTHENTICATION_LOGIN_PATH=null \
  ILIOS_SHIBBOLETH_AUTHENTICATION_LOGOUT_PATH=null \
  ILIOS_SHIBBOLETH_AUTHENTICATION_USER_ID_ATTRIBUTE=null \
  ILIOS_TIMEZONE='America/Los_Angeles' \
  ILIOS_REQUIRE_SECURE_CONNECTION=true \
  ILIOS_KEEP_FRONTEND_UPDATED=true \
  ILIOS_FRONTEND_RELEASE_VERSION=null \
  ILIOS_CAS_AUTHENTICATION_SERVER=null \
  ILIOS_CAS_AUTHENTICATION_VERSION=3 \
  ILIOS_CAS_AUTHENTICATION_VERIFY_SSL=true \
  ILIOS_CAS_AUTHENTICATION_CERTIFICATE_PATH=null \
  ILIOS_ENABLE_TRACKING=false \
  ILIOS_TRACKING_CODE=UA-XXXXXXXX-1

# add all the extra directories necessary for the application
RUN mkdir -p \
    /var/www/ilios/var \
    /var/www/ilios/var/cache \
    /var/www/ilios/var/logs \
    /var/www/ilios/var/session \
    /var/www/ilios/var/tmp \
    /var/www/ilios/vendor

# recursively change user/group ownership of the app root to 'www-data'
RUN chown -R www-data:www-data /var/www/ilios

# give the www-data user a temporary shell in order to build the Ilios app
RUN chsh -s /bin/bash www-data

# change to the context of the 'www-data' user
USER www-data

# as the 'www-data' user, build the app using composer and then remove it
RUN /usr/bin/composer install \
  --working-dir /var/www/ilios \
  --prefer-dist \
  --no-dev \
  --no-progress \
  --no-interaction \
  --no-suggest \
  --classmap-authoritative

# update the frontend
RUN /var/www/ilios/bin/console ilios:maintenance:update-frontend --env=prod

# switch back to the root user to finish up
USER root

# revert the 'www-data' user's shell to its default
RUN chsh -s /usr/sbin/nologin www-data

# note that this app will expose data on port 80
EXPOSE 80
EXPOSE 443

# launch apache httpd as a foreground service
CMD ["apache2-foreground"]
