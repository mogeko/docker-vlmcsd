FROM debian:11 as builder

ARG VERSION=svn1113

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install \
        build-essential ca-certificates clang git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/source

RUN git clone --depth 1 --branch ${VERSION} \
        https://github.com/Wind4/vlmcsd.git /opt/source && \
    CC="clang" make -C /opt/source -j$(nproc)

FROM gcr.io/distroless/base-nossl-debian11:nonroot

LABEL org.opencontainers.image.description="A rootless container running vlmcsd"
LABEL org.opencontainers.image.author="Zheng Junyi <zhengjunyi@live.comn>"
LABEL org.opencontainers.image.licenses="MIT"

COPY --from=builder /opt/source/bin/vlmcsd /usr/bin/vlmcsd
COPY --from=builder /opt/source/etc /etc/vlmcsd

EXPOSE 1688/tcp
ENTRYPOINT [ "/usr/bin/vlmcsd" ]
CMD [ "-D", "-d", "-e" ]
