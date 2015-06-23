#!/bin/bash

# Verification of the emptyness of the easy-rsa directory
if [ `ls -a /etc/openvpn/keys | sed -e "/\.$/d" | wc -l` = 0 ]
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
