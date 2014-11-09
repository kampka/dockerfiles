#!/bin/sh

mkdir -p /data/www
mkdir -p /data/log/nginx
mkdir -p /data/nginx

chown -R www-data:www-data /data/www
chown -R www-data:www-data /data/log/nginx
