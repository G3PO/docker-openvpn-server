# docker-openvpn
Image docker for installing an openvpn server.
You can share the vpn port with an other container (example: NGINX on 443).

##Build

To create the image `lerenn/docker-openvpn-server`, execute the following command on the docker-openvpn-server folder:

    docker build -t lerenn/docker-openvpn-server .

##Run

To run the image with a minimum of arguments, execute the following command :

    docker run -d -e CLIENT1=client --privileged -p 443:443 lerenn/docker-openvpn-server

However, it is strongly recommended to set more arguments. With the following launch command, you will have a persistent server with usable clients configurations :

    docker run -d -e CLIENT1=client -e SERVER_IP=X.X.X.X -e SERVER_PORT=443 --privileged -v /path/in/host:/etc/openvpn -p 443:443 lerenn/docker-openvpn-server

##Collect clients configurations
You will find clients configurations at `/etc/openvpn/clientconf`, or in your mounted volume at the directory `clientconf`.

##Arguments

###Privileged
The image needs to run `iptables` which is only possible if the flag `--privileged` is added to the launch command.
Otherwise, the server won't be able to run properly.

###Environment variables
####Server configuration:
 - **KEY_COUNTRY**: The key country of the server. Defaults to `EN`.
 - **KEY_PROVINCE**: The province of the server. Defaults to `None`.
 - **KEY_CITY**: The city of the server. Defaults to `None`.
 - **KEY_ORG**: The organisation of the server. Defaults to `None`.
 - **KEY_EMAIL**: Your email or the email of the administrator. Defaults to `xxxx@xxx.xx`.
 - **KEY_CN**: Name of your domain. Defaults to `NO`.
 - **KEY_NAME**: Name of your server. Defaults to `None`.
#####Port sharing
 - **SHARE_PORT_CONTAINER**: Name of the container to share a port with (must be linked). Defaults to `none`.
 - **SHARE_PORT_NUMBER**: Port number of the container. Defaults to `443`.
####Clients configuration:
 - **CLIENTX**: The name of one of the server client. You have to replace `X` by the number of the client. Example: `CLIENT1`, `CLIENT2`, ...
 - **SERVER_IP**: The server ip which will be put in the client configuration. Defaults to `A.B.C.D`.
 - **SERVER_PORT**: The server port which will be put in the client configuration (It is the one you will choose when you will launch the image). Defaults to `443`.

###Volumes

#### Server files
The server files and configuration are placed in the volume `/etc/openvpn`. To persist server files and configuration, add this argument to the launch command : `-v /path/in/host:/etc/openvpn`
If the server directory is empty, a new server will be created. Otherwise, the old one will be used.
