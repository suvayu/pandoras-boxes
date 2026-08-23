FROM fedora:latest

ARG EXTRA_PACKAGES=""

RUN dnf -y update && \
    dnf -y install \
        coreutils \
        findutils \
        git \
        less \
        which \
        sudo \
        cmake \
        ninja-build \
        gcc \
        gcc-c++ \
        npm \
        openssl-devel \
        vulkan-headers \
        vulkan-loader-devel \
        spirv-headers-devel \
        glslc \
        $EXTRA_PACKAGES && \
    dnf clean all
