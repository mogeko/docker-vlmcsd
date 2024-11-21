FROM docker.io/library/debian:12 AS builder

ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt-get --no-install-recommends -y install \
        build-essential ca-certificates clang

COPY ./vlmcsd-*/etc/* /opt/vlmcsd/etc/
COPY ./vlmcsd-*/src/* /opt/vlmcsd/src/
COPY ./vlmcsd-*/GNUmakefile /opt/vlmcsd/GNUmakefile
COPY ./vlmcsd-*/Makefile /opt/vlmcsd/Makefile
COPY ./*.patch /opt/

ARG VLMCSD_VERSION="private\ build"
ARG CC="clang"
ENV CC="${CC}" VLMCSD_VERSION="${VLMCSD_VERSION}"
RUN for p in /opt/*.patch; do patch -d /opt/vlmcsd/ -N -p2 < $p; done
RUN MAX_THREADS="$(nproc)" make -C /opt/vlmcsd/

FROM gcr.io/distroless/base-nossl-debian12:nonroot

LABEL org.opencontainers.image.description="A rootless container running vlmcsd"
LABEL org.opencontainers.image.author="Zheng Junyi <zhengjunyi@live.comn>"
LABEL org.opencontainers.image.licenses="MIT"

COPY --from=builder /opt/vlmcsd/bin/vlmcsd /usr/bin/vlmcsd
COPY --from=builder /opt/vlmcsd/etc/vlmcsd.ini /etc/vlmcsd/vlmcsd.ini

EXPOSE 1688/tcp

ENTRYPOINT [ "/usr/bin/vlmcsd" ]
CMD [ "-D", "-d", "-e" ]

COPY --from=builder /opt/vlmcsd/bin/vlmcs /usr/bin/vlmcs
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD [ "/usr/bin/vlmcs", "0.0.0.0:1688" ]
