# Dockerfile for Yocto development environment

FROM ubuntu:22.04

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    gawk wget git-core diffstat unzip texinfo gcc-multilib \
    build-essential chrpath socat cpio python3 python3-pip \
    python3-pexpect xz-utils debianutils iputils-ping \
    libsdl1.2-dev xterm \
    && apt-get clean

# Install optional packages for additional build tools
RUN apt-get update && apt-get install -y \
    python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
    pylint3 xz-utils debianutils iputils-ping \
    && apt-get clean

# Set up a working directory

WORKDIR /workspace

# Set the shell prompt to include the container name
ENV PS1="\[\e[1;32m\]yocto-dev-container \[\e[0m\]:\w\$ "

# User and group management (optional)
# RUN groupadd -r yocto && useradd -r -g yocto yocto
# USER yocto

