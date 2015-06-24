#!/bin/bash

# Relocate to the correct directory
cd `pwd`/$(dirname $0)
cd /etc/openvpn/easy-rsa/

i=1
var=CLIENT1
while [ "${!var}" ]
do
  # Generate keys if doesn't exist
  if [ ! -e "keys/${!var}.key" ]; then
    echo "Keys generation for ${!var}..."
    sed -Ei "s/^export KEY_NAME.*/export KEY_NAME=${!var}/" ./vars
    source ./vars
    ./build-key --batch "${!var}"
    echo "Done."
  fi

  if [ ! -d "/etc/openvpn/clientconf/${!var}" ]; then
    echo "Export files for ${!var}..."
    mkdir "/etc/openvpn/clientconf/${!var}"
    cp /etc/openvpn/ca.crt "/etc/openvpn/clientconf/${!var}/"
    cp /etc/openvpn/ta.key "/etc/openvpn/clientconf/${!var}/"
    cp "keys/${!var}.crt" "/etc/openvpn/clientconf/${!var}/"
    cp "keys/${!var}.key" "/etc/openvpn/clientconf/${!var}/"
    echo "Done."
  fi

  # Passing to the next client
  i=$((i+1))
  var="CLIENT$i"
done
