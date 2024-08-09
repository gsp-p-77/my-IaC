# Use the official Ubuntu 20.04 as a base image
FROM ubuntu:20.04

# Set environment variables to avoid user prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Add Docker's official GPG key and repository
RUN apt-get update -y && \
    apt-get install -y ca-certificates curl sudo gnupg lsb-release && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    apt-get install -y unzip cmake g++ build-essential \
    libboost-all-dev libssl-dev libcurl4-openssl-dev git gdb valgrind gcovr lcov && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add a non-root user (VS Code Dev Containers runs as a non-root user by default)
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash \
    && usermod -aG sudo $USERNAME \
    && usermod -aG docker $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME

# Set the user
USER $USERNAME

# Set the working directory
WORKDIR /workspace

# Copy any additional files or scripts if necessary
# COPY .bashrc /home/$USERNAME/.bashrc

# Expose necessary ports if needed
# EXPOSE 8080

# Default command
CMD ["sleep", "infinity"]
