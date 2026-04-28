FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y \
    git cmake build-essential \
    libvulkan-dev glslc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY whisper.cpp/ .
RUN cmake -B build -DGGML_VULKAN=1 && cmake --build build -j$(nproc)

FROM debian:bookworm-slim AS runtime

RUN apt-get update && apt-get install -y \
    libvulkan1 vulkan-tools \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/build/bin/whisper-cli /usr/local/bin/

CMD ["whisper-cli"]
