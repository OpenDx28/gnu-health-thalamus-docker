# Folowing instructions from: https://en.wikibooks.org/wiki/GNU_Health/Federation_Technical_Guide#Installing_Thalamus
#
# docker build -t opendx/thalamus .
#
# Create a docker container based on the previous image
# docker run -it --rm --name federator --link thalamus_postgres opendx/thalamus
#

FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install \
    apt-utils \
    build-essential \
    git-core \
    gcc \
    curl \
    wget \
    vim \
    openssl \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    python3-dev \
    pkg-config \
    libfreetype6-dev \
    postgresql \
    patch \
    python3-pip \
    libpq-dev \
    sudo

RUN pip3 install wheel thalamus flask-cors uwsgi
RUN groupadd -r thalamus && useradd -r -g thalamus thalamus && \
    echo "thalamus ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/thalamus && \
    chmod 0440 /etc/sudoers.d/thalamus

USER thalamus

# 3.6.1.7, 3.6.1.8
WORKDIR /home/thalamus/

# Make the last a volume
COPY --chown=thalamus:thalamus start.sh /home/thalamus/start.sh

# Copy the file temporarily here. "start.sh" will copy it to the adequate directory
COPY --chown=thalamus:thalamus thalamus.cfg /home/thalamus/thalamus.cfg
COPY --chown=thalamus:thalamus thalamus_uwsgi.ini /home/thalamus/thalamus_uwsgi.ini

ENV PGPASSWORD=thalamus
CMD ["/bin/bash", "/home/thalamus/start.sh"]
#CMD ["sleep", "infinity"]
