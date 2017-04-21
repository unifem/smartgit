# Builds a Docker image for development environment
# with Ubuntu, LXDE, and Jupyter Notebook.
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM unifem/desktop-base:latest
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

ENV SMARTGIT_VER=17_0_3

# Install Java
RUN apt-get update && \
    apt-get install -q -y --no-install-recommends \
        openjdk-8-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install smartgit
RUN curl -O http://www.syntevo.com/static/smart/download/smartgit/smartgit-${SMARTGIT_VER}.deb && \
    dpkg -i smartgit-${SMARTGIT_VER}.deb && \
    echo "@/usr/share/smartgit/bin/smartgit.sh" >> /home/$DOCKER_USER/.config/lxsession/LXDE/autostart && \
    rm -rf /tmp/* /var/tmp/* && \
    chown -R $DOCKER_USER:$DOCKER_USER /home/$DOCKER_USER

