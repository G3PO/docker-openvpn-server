 FROM debian:jessie
 MAINTAINER Louis Fradin <louis.fradin@gmail.com>

 # Update System
 RUN apt-get update && apt-get upgrade -y
 
