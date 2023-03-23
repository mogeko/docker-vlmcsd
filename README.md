# docker-vlmcsd

[![ci_icon]][ci_link] [![docker_pulls]][docker_link] [![image_size]][docker_link]

A rootless container running [vlmcsd](https://github.com/Wind4/vlmcsd).

**Since March 2023, vlmcsd images has been upgraded to a `rootless` container based on ["Distroless" image](https://github.com/GoogleContainerTools/distroless) and compiled with [Buildah](https://buildah.io).** [learn more](#about-distroless-images-and-buildah).

## Usage

Pull this image:

```shell
docker pull ghcr.io/mogeko/vlmcsd:latest
```

Run with docker cli:

```shell
docker run -d --name vlmcsd -p 1688:1688 --restart unless-stopped ghcr.io/mogeko/vlmcsd:latest
```

Run with [docker-compose]:

```yml
---
version: 2.1
services:
  vlmcsd:
    image: ghcr.io/mogeko/vlmcsd:latest
    container_name: vlmcsd
    ports:
      - 1688:1688
    restart: unless-stopped
```

## Parameter

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function            |
| --------- | ------------------- |
| `-p 1688` | tcp connection port |

## About "Distroless" images and Buildah

["Distroless" container image](https://github.com/GoogleContainerTools/distroless) is an application-centered [OCI container image](https://opencontainers.org) launched by Google for the [Kubernetes](https://kubernetes.io) project. It contain **only** your application and its runtime dependencies. They do NOT contain **package managers**, **shells** or any other **programs** you would expect to find in a standard Linux distribution (Your application will be the only **executable program** in the entire container image).

Compared with the traditional complete [Debian](https://hub.docker.com/_/debian) container image, Distroless has an unparalleled <sub>size</sub> advantage, its [minimum](https://github.com/GoogleContainerTools/distroless/blob/main/base/README.md) is only 2MB, less than 2% of the Debian (124MB). Compared with [Alpine Linux](https://hub.docker.com/_/alpine), it has a **smaller attack surface** and better **compatibility** (based on Debian and [`glibc`](https://www.gnu.org/software/libc)).

| Image      | Size   | rootless? | shell? | package-manager? | other programs?    | C library |
| ---------- | ------ | --------- | ------ | ---------------- | ------------------ | --------- |
| distroless | 12.6MB | support   | :x:    | :x:              | :x:                | `glibc`   |
| debian     | 118MB  | support?  | `bash` | `apt-get`        | :white_check_mark: | `glibc`   |
| alpine     | 7.51MB | support?  | `bash` | `apk`            | :white_check_mark: | `musl`    |

As for [Buildah](https://buildah.io). It is a container mirror compilation engine launched by Red Hat. Its biggest selling point is that it allows you to **create a container images in a completely unprivileged environment, that is _"rootless"_**. With the help of Buildah, we were able to **put the entire life cycle of the container's compilation and operation in the user namespace**. So as to protect our digital security.

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
