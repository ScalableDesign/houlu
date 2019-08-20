# Builds a Docker image for Multithreaded version of CalculiX
#
# Authors:
# Laurent ESCALIER <laurent.escalier@scalable-design.com>

# Use intel python for increased performance
FROM intelpython3_full:latest
LABEL maintainer "Scalable Design <contact@scalable-design.com>"
LABEL version "1.0"

USER root
WORKDIR /tmp

ENV DEV_PACKAGES="\
    gfortran \
    f2c \
    libextutils-f77-perl \
    libarpack2-dev \
    libspooles-dev \
    libopenmpi-dev \
    curl \
    "

USER root
WORKDIR /tmp

# Install recommanded packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends $DEV_PACKAGES

COPY ./install_calculix.pl /tmp/
RUN perl /tmp/install_calculix.pl
RUN cp /tmp/ccx_2.15_MT /bin/ccx_2.15_MT
RUN ln -s /bin/ccx_2.15_MT /bin/ccx


########################################################
# Customization for user
########################################################
RUN groupadd -g 61000 simgroup 
RUN useradd -g 61000 -l -m -s /bin/bash -u 61000 simuser
USER simuser
ENV DOCKER_HOME /home/simuser
WORKDIR $DOCKER_HOME

RUN echo "export OMP_NUM_THREADS=\$(nproc)" >> $DOCKER_HOME/.profile && \
    chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME
