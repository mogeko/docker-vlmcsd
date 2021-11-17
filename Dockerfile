FROM alpine:3 as builder

ARG VERSION

RUN apk add --no-cache build-base clang tar

WORKDIR /workspace

ADD https://github.com/Wind4/vlmcsd/archive/refs/tags/${VERSION}.tar.gz /workspace

RUN tar -zxf ${VERSION}.tar.gz -C . \
    && mv vlmcsd-${VERSION}/* . \
    && CC=clang make

FROM alpine:3

COPY --from=builder /workspace/bin/vlmcsd /usr/bin/vlmcsd

EXPOSE 1688/tcp

ENTRYPOINT [ "/usr/bin/vlmcsd" ]

CMD [ "-D", "-d", "-e" ]
