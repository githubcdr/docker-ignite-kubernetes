FROM ubuntu:jammy

# meta
LABEL \
	org.label-schema.maintainer="me codar nl" \
	org.label-schema.name="ignite-kubernetes" \
	org.label-schema.description="Don't ask, inception overfl0w" \
	org.label-schema.version="1.0" \
	org.label-schema.vcs-url="https://github.com/githubcdr/docker-ignite-kubernetes" \
	org.label-schema.schema-version="1.0"

# udev is needed for booting a "real" VM, setting up the ttyS0 console properly
# kmod is needed for modprobing modules
# systemd is needed for running as PID 1 as /sbin/init
# Also, other utilities are installed
RUN apt update && apt install -y curl gnupg apt-transport-https && \
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add && \
    apt update && apt install -y \
    dbus \
    kmod \
    iproute2 \
    iputils-ping \
    net-tools \
    openssh-server \
    sudo \
    systemd \
    udev \
    vim-tiny \
    wget \
    docker.io \
    kubernetes-cni \
    kubectl \
    kubeadm \
    kubelet && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Create the following files, but unset them
RUN echo "" > /etc/machine-id && echo "" > /var/lib/dbus/machine-id

# This container image doesn't have locales installed. Disable forwarding the
# user locale env variables or we get warnings such as:
#  bash: warning: setlocale: LC_ALL: cannot change locale
RUN sed -i -e 's/^AcceptEnv LANG LC_\*$/#AcceptEnv LANG LC_*/' /etc/ssh/sshd_config

# Set the root password to root when logging in through the VM's ttyS0 console
RUN echo "root:root" | chpasswd