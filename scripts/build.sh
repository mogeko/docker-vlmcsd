#!/usr/bin/env bash

set -o errexit

CONTAINER=$(buildah from gcr.io/distroless/base-nossl-debian11:nonroot)
MOUNTPOINT=$(buildah mount ${CONTAINER})

buildah config --label maintainer="Zheng Junyi <zhengjunyi@live.comn>" ${CONTAINER}

install -D -m 755 -o 65532 -g 65532 ${1}/bin/vlmcsd ${MOUNTPOINT}/bin/vlmcsd

buildah config --port 1688 ${CONTAINER}
buildah config --entrypoint '["/bin/vlmcsd"]' ${CONTAINER}
buildah config --cmd '["-D", "-d", "-e" ]' ${CONTAINER}
buildah commit --format docker ${CONTAINER} vlmcsd
buildah unmount ${CONTAINER}
