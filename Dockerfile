FROM ghcr.io/kth8/whisper-server-vulkan:latest
RUN apt-get update && apt-get install -y --only-upgrade \
    libssl3t64 \
    libgnutls30t64 \
    libsystemd0 \
    libudev1 \
    libcap2 \
    sed \
    && rm -rf /var/lib/apt/lists/*
