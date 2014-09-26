# Nginx server generic image source
#
# Version 0.2.0

FROM ubuntu:12.04

MAINTAINER Wiliam Souza <wiliamsouza83@gmail.com>

# base
ENV LANG en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen en_US en_US.UTF-8
RUN dpkg-reconfigure locales
RUN apt-get update

RUN apt-get install -y python-software-properties

# supervisor
RUN apt-get install supervisor -y
RUN update-rc.d -f supervisor disable

ADD etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# start script
ADD bin/startup /usr/local/bin/startup
RUN chmod +x /usr/local/bin/startup

CMD ["/usr/local/bin/startup"]

# environment

# dependencies
RUN apt-get install curl -y

# repos
RUN add-apt-repository ppa:nginx/stable -y
RUN apt-get update

# confd binary
RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.5.0/confd-0.5.0-darwin-amd64 -o /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

# confd configuration
ADD confd /etc/confd

# nginx
RUN apt-get install nginx nginx-extras -y
RUN update-rc.d -f nginx disable

ADD etc/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
