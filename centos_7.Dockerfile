FROM centos:7
MAINTAINER Andy Neff <andyneff@users.noreply.github.com>

#Docker RUN example, pass in the git-lfs checkout copy you are working with
LABEL RUN="docker run -v git-lfs-repo-dir:/src -v repo_dir:/repo"

ENV GIT_SHA256=26831c5e48a8c2bf6a4fede1b38e1e51ffd6dad85952cf69ac520ebd81a5ae82

RUN sed -i 's/mirror\.centos\.org/vault.centos.org/g' /etc/yum.repos.d/*.repo
RUN sed -i 's/^# *baseurl=/baseurl=/' /etc/yum.repos.d/*.repo
RUN sed -i 's/^mirrorlist=/#mirrorlist=/' /etc/yum.repos.d/*.repo

RUN yum -y upgrade
RUN yum install -y centos-release-scl

RUN sed -i 's/mirror\.centos\.org/vault.centos.org/g' /etc/yum.repos.d/CentOS-SCLo-scl*.repo
RUN sed -i 's/^# *baseurl=/baseurl=/' /etc/yum.repos.d/CentOS-SCLo-scl*.repo
RUN sed -i 's/^mirrorlist=/#mirrorlist=/' /etc/yum.repos.d/CentOS-SCLo-scl*.repo

RUN yum install -y rsync rh-ruby30-ruby rh-ruby30-build gcc
RUN yum install -y gettext-devel libcurl-devel openssl-devel perl-CPAN perl-devel zlib-devel make wget autoconf && \
  wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.34.5.tar.gz -O git.tar.gz && \
  [ "$(sha256sum git.tar.gz | cut -d' ' -f1)" = "${GIT_SHA256}" ] && \
  tar -zxf git.tar.gz && \
  cd git-* && \
  make configure && \
  ./configure --prefix=/usr/local && \
  make install && \
  git --version

ARG GOLANG_VERSION=1.24.1
ARG GOLANG_SHA256=cb2396bae64183cdccf81a9a6df0aea3bce9511fc21469fb89a0c00470088073
ARG GOLANG_ARCH=amd64

ENV GOROOT=/usr/local/go
ENV GOTOOLCHAIN=local

RUN cd /usr/local && \
    curl -L -O https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    [ "$(sha256sum go${GOLANG_VERSION}.linux-amd64.tar.gz | cut -d' ' -f1)" = "${GOLANG_SHA256}" ] && \
    tar zxf go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt

#Add the simple build repo script
COPY centos_script.bsh /tmp/

CMD scl enable rh-ruby30 /tmp/centos_script.bsh
