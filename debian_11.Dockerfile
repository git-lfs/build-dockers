FROM debian:bullseye

#Docker RUN example, pass in the git-lfs checkout copy you are working with
LABEL RUN="docker run -v git-lfs-checkout-dir:/src -v repo_dir:/repo"

RUN dpkg --add-architecture i386

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
apt-get install -y --no-install-recommends gettext git dpkg-dev dh-golang ruby-ronn ronn asciidoctor curl build-essential gcc-i686-linux-gnu libc6-dev:i386

ARG GOLANG_VERSION=1.18.2
ARG GOLANG_SHA256=e54bec97a1a5d230fc2f9ad0880fcbabb5888f30ed9666eca4a91c5a32e86cbc
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
