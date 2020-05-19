#!/bin/bash

while sleep 60; do
    echo -n `date +\%H:\%M:\ ` > /tmp/ilios_frontend_updates.log
    cd /var/www/ilios;sudo /var/www/ilios/bin/console messenger:consume async --time-limit=60 >> /tmp/ilios_search_index_updates.log 2>&1
    :
done
