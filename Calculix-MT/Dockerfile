# Builds a Docker image for Multithreaded version of CalculiX
#
# Authors:
# Laurent ESCALIER <laurent.escalier@scalable-design.com>

# Use intel python for increased performance
FROM intelpython/intelpython3_core:latest
LABEL maintainer "Scalable Design <contact@scalable-design.com>"
LABEL version "1.0"

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
WORKDIR /opt

# Install recommanded packages
RUN apt-get update && \
    apt-get install -y build-essential apt-utils

# Install recommanded packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends $DEV_PACKAGES

# Install Calculix
COPY ./install_calculix.pl /opt/
RUN perl /opt/install_calculix.pl && \
    cp /opt/ccx_2.15_MT /bin/ccx_2.15_MT && \
    ln -s /bin/ccx_2.15_MT /bin/ccx

# Install pycalculix
RUN pip install --upgrade pip && \
    pip install pycalculix

# Perform cleanup 
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get autoclean && \
    rm /opt/Makefile && \
    rm /opt/install_calculix.pl

########################################################
# Customization for user
########################################################
RUN useradd -ms /bin/bash  ccxuser
ENV DOCKER_HOME /home/ccxuser
WORKDIR $DOCKER_HOME

COPY ./run_ccx.sh .
RUN chmod a+x run_ccx.sh && \
    chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME
    
########################################################
# APP Tools
########################################################
COPY ./app/* /app/

USER ccxuser
CMD ["/bin/bash"]