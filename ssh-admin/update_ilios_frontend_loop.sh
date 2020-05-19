#!/bin/bash

while sleep 60; do
    echo -n `date +\%H:\%M:\ ` > /tmp/ilios_frontend_updates.log
    cd /var/www/ilios;sudo bin/console ilios:maintenance:update-frontend >> /tmp/ilios_frontend_updates.log 2>&1
    :
done
