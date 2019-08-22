# Builds a Docker image for meshers
#
# Authors:
# Laurent ESCALIER <laurent.escalier@scalable-design.com>

# FROM x11vnc/docker-desktop
FROM ubuntu:19.04
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
    sed 's/#.*//' package_requirement.txt | xargs apt-get install -y

# Install any needed packages specified in python_requirement.txt
COPY python_requirement.txt .
RUN  pip3 install --requirement python_requirement.txt

# Install GMSH
RUN apt-get install -y libglu1 libfontconfig1 libxrender1 && \
    wget http://gmsh.info/bin/Linux/gmsh-4.4.1-Linux64.tgz && \
    tar -xvzf gmsh-4.4.1-Linux64.tgz
ENV PATH="/opt/gmsh-4.4.1-Linux64/bin:${PATH}"

# Install NetGen
RUN apt-get install -y  software-properties-common && \
    apt-get update  && \
    add-apt-repository universe && \
    add-apt-repository -y ppa:ngsolve/ngsolve  && \
    apt-get update  && \
    apt-get install -y netgen python3-netgen

RUN useradd -ms /bin/bash  mesher_user

# Perform cleanup 
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get autoclean

