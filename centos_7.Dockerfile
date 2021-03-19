FROM centos:7
MAINTAINER Andy Neff <andyneff@users.noreply.github.com>

#Docker RUN example, pass in the git-lfs checkout copy you are working with
LABEL RUN="docker run -v git-lfs-repo-dir:/src -v repo_dir:/repo"

ENV GIT_SHA256=fd0197819920a62f4bb62fe1c4b1e1ead425659edff30ff76ff1b14a5919631c

RUN yum install -y rsync ruby ruby-devel gcc
RUN yum install -y gettext-devel libcurl-devel openssl-devel perl-CPAN perl-devel zlib-devel make wget autoconf && \
  wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.16.0.tar.gz -O git.tar.gz && \
  [ "$(sha256sum git.tar.gz | cut -d' ' -f1)" = "${GIT_SHA256}" ] && \
  tar -zxf git.tar.gz && \
  cd git-* && \
  make configure && \
  ./configure --prefix=/usr/local && \
  make install && \
  git --version

ARG GOLANG_VERSION=1.16.2
ARG GOLANG_SHA256=542e936b19542e62679766194364f45141fde55169db2d8d01046555ca9eb4b8

ENV GOROOT=/usr/local/go

RUN cd /usr/local && \
    curl -L -O https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    [ "$(sha256sum go${GOLANG_VERSION}.linux-amd64.tar.gz | cut -d' ' -f1)" = "${GOLANG_SHA256}" ] && \
    tar zxf go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt

#Add the simple build repo script
COPY centos_script.bsh /tmp/

CMD /tmp/centos_script.bsh
