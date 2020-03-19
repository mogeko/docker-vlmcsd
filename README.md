# docker-vlmcsd

![Build](https://github.com/Mogeko/docker-vlmcsd/workflows/Publish%20Docker%20Container/badge.svg)

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

[https://forums.mydigitallife.info/threads/50234-Emulated-KMS-Servers-on-non-Windows-platforms](https://forums.mydigitallife.info/threads/50234-Emulated-KMS-Servers-on-non-Windows-platforms)

[https://github.com/Wind4/vlmcsd](https://github.com/Wind4/vlmcsd)
