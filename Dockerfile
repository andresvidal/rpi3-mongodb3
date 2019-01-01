# Docker Image for MongoDB 3.0.14 on RPi3

FROM resin/rpi-raspbian:stretch

LABEL created_by=https://github.com/andresvidal/rpi3-mongodb3
LABEL binaries=https://andyfelong.com/2017/08/mongodb-3-0-14-for-raspbian-stretch
LABEL mongod_version=3.0.14

# Process binaries
ADD mongodb_stretch_3_0_14_core.tar.gz /usr/bin/
ADD mongodb_stretch_3_0_14_tools.tar.gz /usr/bin/

RUN groupadd -r mongodb && useradd -r -g mongodb mongodb
RUN mkdir -p \
    /data/db \
    /data/configdb \
    /var/log/mongodb \
&& chown -R mongodb:mongodb \
    /usr/bin/mongo* \
    /data/db \
    /data/configdb \
    /var/log/mongodb

COPY ./docker-entrypoint.sh /
RUN ["chmod", "+x", "/docker-entrypoint.sh"]

# Define mountable directories
VOLUME /data/db /data/configdb

# Define working directory
WORKDIR /data

# Expose ports
# - 27017: process
# - 28017: http
EXPOSE 27017
EXPOSE 28017

# make sure that mongod performs a clean shutdown
# when container is stopped
STOPSIGNAL SIGINT

#ENTRYPOINT ["/sbin/tini", "--"]
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mongod"] 
