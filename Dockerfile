
FROM amazonlinux:2023

RUN dnf update -y && \
    dnf swap -y curl-minimal curl && \
    dnf install -y \
        gcc14 \
        gcc14-c++ \
        tar \
        make \
        cmake \
        git \
        gzip \
        bubblewrap \
        rpm-build \
        openssl-devel \
        openssh-clients \
    && dnf clean all


# Configure GCC 14 as the default compiler
# Expose GCC 14 binaries under conventional names, excluding ld.
# Expose GCC 14 binaries under conventional names, excluding ld.
RUN for binary in /usr/bin/gcc14-*; do \
        [ -e "$binary" ] || continue; \
        name="${binary##*/gcc14-}"; \
        [ "$name" = "ld" ] && continue; \
        target="/usr/bin/$name"; \
        [ -e "$target" ] && [ "$binary" -ef "$target" ] && continue; \
        ln -sfn "$binary" "$target"; \
    done

# Create build user
RUN useradd -m -s /bin/bash builder
RUN mkdir -p /home/builder/.ssh && chown builder:builder /home/builder/.ssh

USER builder
WORKDIR /home/builder

# Install cxpm
RUN curl -fsSLO https://soft-forge.dev/cxpm/download/cxpm-0.4.0-linux-x86_64.tar.gz && \
    tar -xzf cxpm-0.4.0-linux-x86_64.tar.gz && \
    mkdir -p "$HOME/.local" && \
    cp -r cxpm-0.4.0-linux-x86_64/. "$HOME/.local/" && \
    rm -rf cxpm-0.4.0-linux-x86_64.tar.gz cxpm-0.4.0-linux-x86_64

ENV PATH="/home/builder/.local/bin:${PATH}"

# Verify installation
RUN cxpm help

CMD ["/bin/bash"]
