FROM phusion/baseimage
MAINTAINER Eugene Tolmachev 
ENV DEBIAN_FRONTEND noninteractive

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ENV DISABLE_SSH 1
ENV SALT_VERSION 2015.8
ENV LOG_LEVEL debug

RUN apt-get update && apt-get install -yq --no-install-recommends wget
RUN echo "deb http://repo.saltstack.com/apt/ubuntu/ubuntu14/${SALT_VERSION}/ trusty main" >> /etc/apt/sources.list
RUN wget -O - http://repo.saltstack.com/apt/ubuntu/ubuntu14/${SALT_VERSION}/SALTSTACK-GPG-KEY.pub | apt-key add -

RUN apt-get update && apt-get install -yq --no-install-recommends \
  salt-master=${SALT_VERSION}\* \ 
  git \
  pkg-config \
  gcc build-essential cmake \
  python-dev python-pip \
  libffi-dev libssh-dev zlib1g-dev libssl-dev \
  libhttp-parser-dev virt-what
#salt-api python-cherrypy3

RUN cd /tmp && \
    wget https://github.com/libgit2/libgit2/archive/v0.22.2.tar.gz && \
    tar xzf v0.22.2.tar.gz && \
    cd libgit2-0.22.2/ && \
    cmake . && \
    make && \
    make install && \
    ldconfig && \
    pip install -I cffi && \
    pip install -I pygit2==0.22.1 && \
    pip install -I pyOpenSSL==0.15.1 && \
    cd /

# cleanup
RUN apt-get purge gcc -yq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup Service Startup Scripts
RUN mkdir /etc/service/salt-master
ADD salt-master.sh /etc/service/salt-master/run
RUN chmod +x /etc/service/salt-master/run

VOLUME ["/etc/salt"]
EXPOSE 4505 4506 4430
