FROM debian:wheezy
MAINTAINER Louis Fradin <louis.fradin@gmail.com>

# This image is base on the tutorial made by Nicolargo
# http://blog.nicolargo.com/2010/10/installation-dun-serveur-openvpn-sous-debianubuntu.html

# Update System
RUN apt-get update && apt-get upgrade -y --force-yes

# Install requirements
RUN apt-get install iptables openssl openvpn -y

# Minimal configuration of the server
RUN mkdir /etc/openvpn/easy-rsa/
COPY server.conf /etc/openvpn/server.conf

# Add the init script and configuration scripts
COPY docker-entrypoint /docker-entrypoint
RUN chmod +x  /docker-entrypoint/*

# Environment variables
ENV KEY_COUNTRY EN
ENV KEY_PROVINCE None
ENV KEY_CITY None
ENV KEY_ORG None
ENV KEY_EMAIL xxxx@xxx.xx
ENV KEY_CN NO
ENV KEY_NAME None

# Volumes
VOLUME /etc/openvpn/easy-rsa/
VOLUME /etc/openvpn/clientconf

EXPOSE 443
CMD /docker-entrypoint/docker-entry.sh
