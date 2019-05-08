FROM alpine:latest

ENV VERSION svn

RUN apk update \
    && apk upgrade \
    && apk add --no-cache build-base gcc abuild binutils cmake \
    && cd / \
    && wget https://github.com/Wind4/vlmcsd/archive/"$VERSION".tar.gz \
    && tar xzf "$VERSION".tar.gz \
    && cd vlmcsd-"$VERSION" \
    && make \
    && chmod +x bin/vlmcsd \
    && mv bin/vlmcsd / \
    && cd / \
    && apk del build-base gcc abuild binutils cmake \
    && rm -rf /vlmcsd-"$VERSION"  \
    && rm -rf /var/cache/apk/* \
    && /vlmcsd -V

EXPOSE 1688

CMD ["/vlmcsd", "-D", "-d", "-t", "3", "-e", "-v"]