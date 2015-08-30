#!/bin/bash

# Verification of the emptyness of the easy-rsa directory
if [ `ls -a /etc/openvpn/easy-rsa/ | sed -e "/\.$/d" | wc -l` = 0 ]
then
  echo "/etc/openvpn/easy-rsa/ is empty"
  echo "Configuring the server..."
  /docker-entrypoint/server-configuration.sh
  echo "Configuration is finished."
else
  echo "/etc/openvpn/easy-rsa/ is not empty"
  echo "Configuration skipped."
fi

echo "Mandatory rules to unlock access..."
iptables -I FORWARD -i tun0 -j ACCEPT
iptables -I FORWARD -o tun0 -j ACCEPT
iptables -I OUTPUT -o tun0 -j ACCEPT
echo "Done."

echo "Adresse translation..."
iptables -A FORWARD -i tun0 -o eth0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.8.0.2/24 -o eth0 -j MASQUERADE
echo "Done."

# Share port
if [ $SHARE_PORT_CONTAINER != "none" ]; then
  /docker-entrypoint/port-sharing.sh
fi

# Generate clients
/docker-entrypoint/clients-configuration.sh

# Launch openvpn
/etc/init.d/openvpn start

# Make the docker turn on himself
while [ true ]; do
  sleep 60
done
