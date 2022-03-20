FROM debian:bullseye

#Docker RUN example, pass in the git-lfs checkout copy you are working with
LABEL RUN="docker run -v git-lfs-checkout-dir:/src -v repo_dir:/repo"

RUN dpkg --add-architecture i386

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
apt-get install -y --no-install-recommends gettext git dpkg-dev dh-golang ruby-ronn ronn curl build-essential gcc-i686-linux-gnu libc6-dev:i386

ARG GOLANG_VERSION=1.17.8
ARG GOLANG_SHA256=980e65a863377e69fd9b67df9d8395fd8e93858e7a24c9f55803421e453f4f99
ARG GOLANG_ARCH=amd64

ENV GOROOT=/usr/local/go

RUN cd /usr/local && \
    curl -L -O https://golang.org/dl/go${GOLANG_VERSION}.linux-${GOLANG_ARCH}.tar.gz && \
    [ "$(sha256sum go${GOLANG_VERSION}.linux-${GOLANG_ARCH}.tar.gz | cut -d' ' -f1)" = "${GOLANG_SHA256}" ] && \
    tar zxf go${GOLANG_VERSION}.linux-${GOLANG_ARCH}.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt

COPY debian_script.bsh /tmp/

CMD /tmp/debian_script.bsh
