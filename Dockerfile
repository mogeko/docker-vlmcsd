FROM docker.io/library/debian:12 as builder

ARG VERSION=svn1113

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install \
        build-essential ca-certificates clang && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/source

ADD https://github.com/Wind4/vlmcsd/archive/${VERSION}.tar.gz /tmp
RUN tar -xzf /tmp/${VERSION}.tar.gz --strip-components=1 && \
    CC="clang" make vlmcsd vlmcs -j$(nproc)

FROM gcr.io/distroless/base-nossl-debian12:nonroot

LABEL org.opencontainers.image.description="A rootless container running vlmcsd"
LABEL org.opencontainers.image.author="Zheng Junyi <zhengjunyi@live.comn>"
LABEL org.opencontainers.image.licenses="MIT"

COPY --from=builder /opt/source/bin/vlmcsd /usr/bin/vlmcsd
COPY --from=builder /opt/source/etc /etc/vlmcsd

EXPOSE 1688/tcp

ENTRYPOINT [ "/usr/bin/vlmcsd" ]
CMD [ "-D", "-d", "-e" ]

COPY --from=builder /opt/source/bin/vlmcs /usr/bin/vlmcs
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD [ "/usr/bin/vlmcs", "0.0.0.0:1688" ]
