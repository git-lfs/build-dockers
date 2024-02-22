FROM rockylinux/rockylinux:8

RUN yum -y upgrade
RUN yum install -y rsync ruby ruby-devel rubygems-devel gcc
RUN yum install -y gettext-devel libcurl-devel openssl-devel perl-CPAN perl-devel zlib-devel make wget autoconf git

ARG GOLANG_VERSION=1.21.7
ARG GOLANG_SHA256=13b76a9b2a26823e53062fa841b07087d48ae2ef2936445dc34c4ae03293702c
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
