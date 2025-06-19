FROM rockylinux/rockylinux:10

RUN dnf -y upgrade
RUN dnf install -y rsync ruby ruby-devel rubygems-devel gcc 'dnf-command(config-manager)'
RUN dnf install -y gettext-devel libcurl-devel openssl-devel perl-CPAN perl-devel zlib-devel make wget autoconf git

RUN dnf config-manager --set-enabled crb
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
RUN dnf install -y rubygem-asciidoctor

ARG GOLANG_VERSION=1.24.4
ARG GOLANG_SHA256=77e5da33bb72aeaef1ba4418b6fe511bc4d041873cbf82e5aa6318740df98717
ARG GOLANG_ARCH=amd64

ENV GOROOT=/usr/local/go
ENV GOTOOLCHAIN=local

RUN cd /usr/local && \
    curl -L -O https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    [ "$(sha256sum go${GOLANG_VERSION}.linux-amd64.tar.gz | cut -d' ' -f1)" = "${GOLANG_SHA256}" ] && \
    tar zxf go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt

COPY centos_script.bsh /tmp/

CMD /tmp/centos_script.bsh
