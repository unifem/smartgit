# Builds a Docker image with Ubuntu 16.04, g++-5.4, and Smartgit
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM x11vnc/desktop:light
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

ARG SMARTGIT_VER=17.0.4

# Install Java
RUN apt-get update && \
    apt-get install -q -y --no-install-recommends \
        git \
        openjdk-8-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install smartgit
RUN /bin/bash -c 'curl -O http://www.syntevo.com/static/smart/download/smartgit/smartgit-${SMARTGIT_VER//\./_}.deb && \
    dpkg -i smartgit-${SMARTGIT_VER//\./_}.deb && \
    echo "@/usr/share/smartgit/bin/smartgit.sh" >> /home/$DOCKER_USER/.config/lxsession/LXDE/autostart && \
    rm -rf /tmp/* /var/tmp/* && \
    echo "mkdir -p $DOCKER_HOME/.config/smartgit" >> $DOCKER_HOME/.profile && \
    ln -s -f $DOCKER_HOME/.config/smartgit $DOCKER_HOME/.smartgit && \
    chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME'

WORKDIR $DOCKER_HOME
