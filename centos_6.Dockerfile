FROM centos:6
MAINTAINER Andy Neff <andyneff@users.noreply.github.com>

#Docker RUN example, pass in the git-lfs checkout copy you are working with
LABEL RUN="docker run -v git-lfs-repo-dir:/src -v repo_dir:/repo"

ENV GIT_SHA256=fd0197819920a62f4bb62fe1c4b1e1ead425659edff30ff76ff1b14a5919631c

RUN yum install -y epel-release rsync tar
RUN yum install -y gcc libcurl-devel gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel make wget autoconf && \
  wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.16.0.tar.gz -O git.tar.gz && \
  [ "$(sha256sum git.tar.gz | cut -d' ' -f1)" = "${GIT_SHA256}" ] && \
  tar -zxf git.tar.gz && \
  cd git-* && \
  make configure && \
  ./configure --prefix=/usr/local && \
  make install && \
  git --version

ARG GOLANG_VERSION=1.13.4
ARG GOLANG_SHA256=692d17071736f74be04a72a06dab9cac1cd759377bd85316e52b2227604c004c

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
