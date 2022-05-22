# syntax=docker/dockerfile:1
FROM nginx:1.21.6
COPY configs/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80/tcp
EXPOSE 443/tcp