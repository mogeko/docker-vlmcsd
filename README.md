# docker-vlmcsd

[![ci_icon]][ci_link] [![docker_pulls]][docker_link] [![image_size]][docker_link]

A docker image running vlmcsd

## Usage

Pull this image:

```shell
docker pull mogeko/vlmcsd
```

Run with docker cli:

```shell
docker run -d --name vlmcsd -p 1688:1688 --restart unless-stopped mogeko/vlmcsd
```

Run with [docker-compose]:

```yml
---
version: 2.1
services:
  vlmcsd:
    image: mogeko/vlmcsd
    container_name: vlmcsd
    ports:
      - 1688:1688
    restart: unless-stopped
```

## Parameter

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function            |
|-----------|---------------------|
| `-p 1688` | tcp connection port |

## Sources

<https://forums.mydigitallife.info/threads/50234-Emulated-KMS-Servers-on-non-Windows-platforms>

<https://github.com/Wind4/vlmcsd>


## License

The code in this project is released under the [MIT License][license].

<!-- badge -->

[ci_icon]: https://github.com/mogeko/docker-vlmcsd/actions/workflows/auto-update.yml/badge.svg
[ci_link]: https://github.com/mogeko/docker-vlmcsd/actions/workflows/auto-update.yml
[docker_pulls]: https://img.shields.io/docker/pulls/mogeko/vlmcsd?logo=docker
[image_size]: https://img.shields.io/docker/image-size/mogeko/vlmcsd?logo=docker
[docker_link]: https://hub.docker.com/r/mogeko/vlmcsd

<!-- links -->
[docker-compose]: https://docs.docker.com/compose
[license]: https://github.com/mogeko/docker-vlmcsd/blob/master/LICENSE
