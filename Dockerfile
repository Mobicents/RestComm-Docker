FROM phusion/baseimage:0.9.16

MAINTAINER George Vagenas - gvagenas@telestax.com

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

RUN apt-get update && apt-get install -y screen wget ipcalc bsdtar openjdk-7-jre-headless && apt-get autoremove && apt-get autoclean && rm -rf /var/lib/apt/lists/*

RUN wget -qc https://s3-us-west-2.amazonaws.com/restcommdocker/Mobicents-Restcomm-JBoss-AS7-7.3.0.641.zip -O- | bsdtar -xvf - -C /opt/ && mv /opt/Mobicents-Restcomm-JBoss-AS7-*/ /opt/Mobicents-Restcomm-JBoss-AS7/

EXPOSE 5080/udp
EXPOSE 5080/tcp
EXPOSE 5082/tcp
EXPOSE 8080/tcp
EXPOSE 65000-65535/udp

#VOLUME /opt/restcomm_workspace

RUN mkdir /etc/service/restcomm
ADD ./restcomm_service.sh /etc/service/restcomm/run

RUN rm /opt/Mobicents-Restcomm-JBoss-AS7/bin/restcomm/start-restcomm.sh
ADD ./start-restcomm.sh /opt/Mobicents-Restcomm-JBoss-AS7/bin/restcomm/start-restcomm.sh
