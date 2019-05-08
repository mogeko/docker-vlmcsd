FROM alpine:latest

RUN apk update \
    && apk upgrade \
    && apk add --no-cache build-base gcc abuild binutils cmake git \
    && cd / \
    && git clone https://github.com/Wind4/vlmcsd.git vlmcsd-git \
    && cd vlmcsd-git \
    && make \
    && chmod +x bin/vlmcsd \
    && mv bin/vlmcsd / \
    && cd / \
    && apk del build-base gcc abuild binutils cmake git \
    && rm -rf /vlmcsd-git  \
    && rm -rf /var/cache/apk/* \
    && /vlmcsd -V

EXPOSE 1688

CMD ["/vlmcsd", "-D", "-d", "-t", "3", "-e", "-v"]