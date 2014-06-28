#!/bin/bash
cd /etc

sed -i "s/{{UPSTREAM_IP}}/$APP1_PORT_8080_TCP_ADDR/g" nginx.conf
sed -i "s/{{UPSTREAM_PORT}}/$APP1_PORT_8080_TCP_PORT/g" nginx.conf

nginx -c /etc/nginx.conf
