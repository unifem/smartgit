# Builds a Docker image for development environment
# with Ubuntu, LXDE, and Jupyter Notebook.
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM x11vnc/ubuntu:latest
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

ENV SMARTGIT_VER=17_0_3

# Set up user so that we do not run as root
RUN add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
          git \
          meld && \
    echo "oracle-java8-installer  shared/accepted-oracle-license-v1-1 boolean true" > \
          oracle-license-debconf && \
    /usr/bin/debconf-set-selections oracle-license-debconf && \
    apt-get install -q -y --no-install-recommends \
           oracle-java8-installer oracle-java8-set-default && \
    apt-get clean && \
    curl -O http://www.syntevo.com/static/smart/download/smartgit/smartgit-${SMARTGIT_VER}.deb && \
    dpkg -i smartgit-${SMARTGIT_VER}.deb && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

########################################################
# Customization for user
########################################################
ENV UE_USER=unifem

RUN usermod -l $UE_USER -d /home/$UE_USER -m $DOCKER_USER && \
    groupmod -n $UE_USER $DOCKER_USER && \
    echo "$UE_USER:docker" | chpasswd && \
    echo "$UE_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    sed -i "s/$DOCKER_USER/$UE_USER/" /home/$UE_USER/.config/pcmanfm/LXDE/desktop-items-0.conf && \
    chown -R $UE_USER:$UE_USER /home/$UE_USER

ENV DOCKER_USER=$UE_USER \
    DOCKER_GROUP=$UE_USER \
    DOCKER_HOME=/home/$UE_USER \
    HOME=/home/$UE_USER

WORKDIR $DOCKER_HOME

USER root
ENTRYPOINT ["/sbin/my_init","--quiet","--","/sbin/setuser","unifem","/bin/bash","-l","-c"]
CMD ["/bin/bash","-l","-i"]
