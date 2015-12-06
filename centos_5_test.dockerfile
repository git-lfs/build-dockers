FROM centos:5
MAINTAINER Andy Neff <andyneff@users.noreply.github.com>

#Docker RUN example, pass in the git-lfs checkout copy you are working with
LABEL RUN="docker run -v git-lfs-repo-dir:/src -v repo_dir:/repo"

ENV GOLANG_VERSION=[{GOLANG_VERSION}]

ENV GOROOT=/usr/local/go

RUN yum install -y curl && \
    cd /usr/local && \
    curl -L -O https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    tar zxf go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt

COPY test_lfs.bsh /tmp/test_lfs.bsh

CMD yum install -y curl.x86_64 && \
    curl -L -O http://${REPO_HOSTNAME:-git-lfs.github.com}/centos/5/RPMS/noarch/git-lfs-repo-release-1-1.el5.noarch.rpm && \
    rpm --import http://${REPO_HOSTNAME:-git-lfs.github.com}/centos/5/RPM-GPG-KEY-GITLFS && \
    yum install -y git-lfs-repo-release-1-1.el5.noarch.rpm &&\
    yum install -y epel-release &&\
    yum install -y git-lfs.x86_64 && \
    git-lfs && \
    yum install -y perl-Digest-SHA golang which && \
    /tmp/test_lfs.bsh
