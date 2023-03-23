FROM debian:11 as builder

ARG VERSION=svn1113

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install \
        build-essential ca-certificates clang git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

RUN git clone --depth 1 --branch ${VERSION} \
        https://github.com/Wind4/vlmcsd.git /workspace && \
    CC=clang make -j$(nproc)

FROM gcr.io/distroless/base-nossl-debian11:nonroot

COPY --from=builder /workspace/bin/vlmcsd /usr/bin/vlmcsd

EXPOSE 1688/tcp

ENTRYPOINT [ "/usr/bin/vlmcsd" ]

CMD [ "-D", "-d", "-e" ]
