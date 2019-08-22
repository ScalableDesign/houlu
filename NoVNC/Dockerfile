# Builds a Docker image for noVNC
#
# Authors:
# Laurent ESCALIER <laurent.escalier@scalable-design.com>

FROM ubuntu:18.04
LABEL maintainer "Scalable Design <contact@scalable-design.com>"
LABEL version "1.0"

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set correct environment variables
ENV HOME /root \
    DEBIAN_FRONTEND noninteractive \
    LC_ALL C.UTF-8 \
    LANG en_US.UTF-8 \
    LANGUAGE en_US.UTF-8 \
    TZ=Europe/Paris \
    SCREEN_RESOLUTION 1024x768 \
    REMOTE_HOST=localhost \
    REMOTE_PORT=5900

USER root
WORKDIR /opt

# Install any needed packages specified in package_requirement.txt
COPY package_requirement.txt .

RUN apt-get update && \
    sed 's/#.*//' package_requirement.txt | xargs apt-get install -y --no-install-recommends

# NoVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC && \
    git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify && \
    rm -rf /opt/noVNC/.git && \
    rm -rf /opt/noVNC/utils/websockify/.git && \
    cd /root/noVNC && \
    npm install npm@latest && \
    npm install && \
    ./utils/use_require.js --as commonjs --with-app && \
    cp /opt/noVNC/node_modules/requirejs/require.js /opt/noVNC/build && \
    sed -i -- "s/ps -p/ps -o pid | grep/g" /opt/noVNC/utils/launch.sh && \
    apt-get remove -y git nodejs-npm nodejs

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8081

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
