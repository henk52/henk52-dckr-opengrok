# henk52-dckr-opengrok
OpenGrok docker creation.

sudo docker build . 

sudo docker run -d -p 8080:8080 2ba81e29126f


sudo docker ps

sudo docker cp ~/my_src.zip 2dea16db748e:/var/opengrok/src

sudo docker cp 2dea16db748e:/var/log/tomcat/catalina.2017-11-23.log .

# Carefull: ctrl-c goes to the app, not the attach command.
sudo docker attach 170cc4e5962d


/var/log/supervisor/supervisord.log
/var/log/tomcat/catalina.2017-11-23.log

# Troubleshooting

#### FATAL ERROR: Unable to determine Deployment Directory for  Tomcat - Aborting!

Put this in the Dockerfile:

# required by /opt/opengrok/bin/OpenGrok deploy
ENV OPENGROK_TOMCAT_BASE=/var/lib/tomcat

