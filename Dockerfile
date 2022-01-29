FROM ubuntu:20.04

# Setup timezone for avoid tzdata hang
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y wget git qemu-system qemu-utils python3 python3-pip \
        gcc libelf-dev libssl-dev bc flex bison vim bzip2 cpio gdb

# Download kernel
RUN mkdir -p /sources
WORKDIR /sources
RUN git clone --depth=1 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
RUN wget https://busybox.net/downloads/busybox-1.32.1.tar.bz2
RUN tar xvjf busybox-1.32.1.tar.bz2

# Setup GEF
RUN bash -c "$(curl -fsSL http://gef.blah.cat/sh)"

# initial build, so as to speed up development
COPY ./scripts/build-k.sh /sources
RUN /sources/build-k.sh

WORKDIR /scripts
