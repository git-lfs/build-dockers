FROM debian:bullseye

#Docker RUN example, pass in the git-lfs checkout copy you are working with
LABEL RUN="docker run -v git-lfs-checkout-dir:/src -v repo_dir:/repo"

RUN dpkg --add-architecture i386

RUN echo "deb http://archive.debian.org/debian bullseye main contrib non-free" >/etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian bullseye-updates main contrib non-free" >>/etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian bullseye-backports main contrib non-free" >>/etc/apt/sources.list

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
    apt-get install -y --no-install-recommends ca-certificates

RUN echo "deb [check-valid-until=no] https://security.debian.org/debian-security bullseye-security main contrib non-free" >>/etc/apt/sources.list && \
    echo "deb [check-valid-until=no] https://snapshot.debian.org/archive/debian-security/20260831T211327Z bullseye-security main contrib non-free" >>/etc/apt/sources.list

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
apt-get install -y --no-install-recommends gettext git dpkg-dev dh-golang asciidoctor curl build-essential gcc-i686-linux-gnu libc6-dev:i386

ARG GOLANG_VERSION=1.27.0
ARG GOLANG_SHA256=675c26c449cbb18fc24b74650de1eabbae6e16f64326fd85a283fb3b58280685
ARG GOLANG_ARCH=amd64

ENV GOROOT=/usr/local/go
ENV GOTOOLCHAIN=local

RUN cd /usr/local && \
    curl -L -O https://golang.org/dl/go${GOLANG_VERSION}.linux-${GOLANG_ARCH}.tar.gz && \
    [ "$(sha256sum go${GOLANG_VERSION}.linux-${GOLANG_ARCH}.tar.gz | cut -d' ' -f1)" = "${GOLANG_SHA256}" ] && \
    tar zxf go${GOLANG_VERSION}.linux-${GOLANG_ARCH}.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt

COPY debian_script.bsh /tmp/

CMD /tmp/debian_script.bsh --add-i386
