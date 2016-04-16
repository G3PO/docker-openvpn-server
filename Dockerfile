FROM debian:jessie
MAINTAINER Anthony GUEGUEN anthony.gueg@gmail.com

# This image is adapted from the tutorial made by Nicolargo at
# http://blog.nicolargo.com/2010/10/installation-dun-serveur-openvpn-sous-debianubuntu.html
# to Debian jessie

# Update System
RUN apt-get update && apt-get upgrade -y --force-yes && \
    apt-get install openssl openvpn git iptables -y && \
    mkdir -p /etc/openvpn/easy-rsa/

# Minimal configuration of the server
COPY server.conf /etc/openvpn/server.conf
COPY client.conf /etc/openvpn/client.conf
#COPY openssl-1.0.0.cnf /etc/openvpn/
RUN cp -r /etc/openvpn /etc/openvpn-model

# Add the init script and configuration scripts
COPY docker-entrypoint /docker-entrypoint
RUN chmod +x  /docker-entrypoint/*

# Environment variables
ENV KEY_COUNTRY FR
ENV KEY_PROVINCE test
ENV KEY_CITY test
ENV KEY_ORG test
ENV KEY_EMAIL test@test.test
ENV KEY_CN test
ENV KEY_NAME notatest
ENV SERVER_IP A.B.C.D
ENV SERVER_PORT 443
ENV SHARE_PORT_CONTAINER test
ENV SHARE_PORT_NUMBER 443
ENV KEY_ALTNAMES="DNS:${KEY_CN}"
ENV KEY_SIZE=2048

# Volumes
VOLUME /etc/openvpn/

EXPOSE 443
CMD /docker-entrypoint/docker-entrypoint.sh
