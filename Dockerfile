FROM docker.io/library/debian:12 AS builder

ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt-get -y install \
        build-essential ca-certificates clang && \
    rm -rf /var/lib/apt/lists/*

COPY ./vlmcsd-*/etc /opt/vlmcsd/etc
COPY ./vlmcsd-*/src /opt/vlmcsd/src
COPY ./vlmcsd-*/GNUmakefile /opt/vlmcsd/GNUmakefile
COPY ./vlmcsd-*/Makefile /opt/vlmcsd/Makefile

WORKDIR /opt/vlmcsd

ARG VERSION="private\ build"
ARG CC="clang"
ENV VLMCSD_VERSION="${VERSION}"
RUN CC="${CC}" make -j$(nproc)

FROM gcr.io/distroless/base-nossl-debian12:nonroot

LABEL org.opencontainers.image.description="A rootless container running vlmcsd"
LABEL org.opencontainers.image.author="Zheng Junyi <zhengjunyi@live.comn>"
LABEL org.opencontainers.image.licenses="MIT"

COPY --from=builder /opt/vlmcsd/bin/vlmcsd /usr/bin/vlmcsd
COPY --from=builder /opt/vlmcsd/etc /etc/vlmcsd

EXPOSE 1688/tcp

ENTRYPOINT [ "/usr/bin/vlmcsd" ]
CMD [ "-D", "-d", "-e" ]

COPY --from=builder /opt/vlmcsd/bin/vlmcs /usr/bin/vlmcs
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD [ "/usr/bin/vlmcs", "0.0.0.0:1688" ]
