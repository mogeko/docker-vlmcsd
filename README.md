# docker-vlmcsd

[![Build Status](https://img.shields.io/docker/cloud/build/mogeko/vlmcsd.svg?label=Docker&maxAge=600)](https://hub.docker.com/r/mogeko/vlmcsd)

A docker image running vlmcsd

## Usage

Copy and paste to pull this image:

```
docker pull mogeko/vlmcsd
```

Run:

```
docker run -d -p 1688:1688 --restart=always --name vlmcsd mogeko/vlmcsd
```

To view docker log (change 'vlmcsd' with the docker's name):

```
docker logs vlmcsd
```

## Sources

<https://forums.mydigitallife.info/threads/50234-Emulated-KMS-Servers-on-non-Windows-platforms>

<https://github.com/Wind4/vlmcsd>
