FROM fedora:25
MAINTAINER Henry K

# expose the kibana port.
EXPOSE 8080/tcp

# https://github.com/Krijger/docker-cookbooks/blob/master/supervisor/Dockerfile
# supervisor installation &&
# create directory for child images to store configuration in
RUN dnf install -y supervisor && \
  mkdir -p /var/log/supervisor && \
  mkdir -p /etc/supervisor/conf.d

# supervisor base configuration
ADD supervisor.conf /etc/supervisor.conf
ADD opengrok.d.conf /etc/supervisor/conf.d/


# required by /opt/opengrok/bin/OpenGrok deploy
ENV OPENGROK_TOMCAT_BASE=/var/lib/tomcat

RUN mkdir /vagrant

COPY UnpackAndIndexNewFiles.sh /

# COPY <src> ... <dst>
COPY opengrok*.tar.gz /vagrant/

RUN dnf install -y tomcat ctags-etags

RUN mkdir /var/opengrok &&\
     mkdir /var/opengrok/data &&\
     mkdir /var/opengrok/src &&\
     mkdir /var/opengrok/etc &&\
     mkdir /var/opengrok/log &&\
     cd /opt; tar -zxf /vagrant/opengrok*.tar.gz &&\
     ln -s /opt/opengrok* /opt/opengrok &&\
     /opt/opengrok/bin/OpenGrok deploy &&\
     chown -R tomcat /var/opengrok

# TODO N Find out what this was suppose to do.
#RUN     /opt/opengrok/bin/OpenGrok update 


# A container’s main running process is the ENTRYPOINT and/or CMD at the end of the Dockerfile
# https://docs.docker.com/engine/admin/multi-service_container/

# Functionally, ENTRYPOINT is akin to the CMD instruction, but the major difference between the two is that the entry point
#   application is launched using the ENTRYPOINT instruction, which cannot be overridden
#   using the docker run subcommand arguments.

RUN mkdir /var/log/supervisor_child

CMD ["supervisord", "-c", "/etc/supervisor.conf"]
