# Base image
FROM ubuntu:jammy

# Set environment variables for non-interactive apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Set the locale environment variables
ENV LANG=de_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install necessary packages
RUN apt-get update && apt-get install -y \
    gawk wget git diffstat unzip texinfo gcc build-essential chrpath \
    socat cpio python3 python3-pip python3-pexpect xz-utils debianutils 

RUN apt-get install -y locales

RUN locale-gen en_US.utf8

RUN apt-get install -y iputils-ping python3-git python3-jinja2 python3-subunit \
   zstd liblz4-tool file libacl1 sudo

# Create a non-root user with sudo privileges
RUN groupadd -g 1000 yocto && \
    useradd -m -u 1000 -g yocto -s /bin/bash yocto && \
    echo 'yocto ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set the non-root user as default
USER yocto
WORKDIR /home/yocto

# Default command
CMD [ "bash" ]
