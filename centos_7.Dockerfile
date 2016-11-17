FROM centos:7
MAINTAINER Andy Neff <andyneff@users.noreply.github.com>

#Docker RUN example, pass in the git-lfs checkout copy you are working with
LABEL RUN="docker run -v git-lfs-repo-dir:/src -v repo_dir:/repo"

RUN yum install -y rsync git ruby ruby-devel gcc

ARG GOLANG_VERSION=1.7.3

ENV GOROOT=/usr/local/go

RUN cd /usr/local && \
    curl -L -O https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    tar zxf go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt

#The purpose of this is to build and install everything needed to build git-lfs
#Next time. So that the LONG build/installed in centos are only done once, and
#stored in the image.

#Set to master if you want the latest, but IF there is a failure,
#the docker will not build, so I decided to make a stable version the default
ARG DOCKER_LFS_BUILD_VERSION=release-1.5

ADD https://github.com/git-lfs/git-lfs/archive/${DOCKER_LFS_BUILD_VERSION}.tar.gz /tmp/docker_setup/
RUN cd /tmp/docker_setup/; \
    tar zxf ${DOCKER_LFS_BUILD_VERSION}.tar.gz; \
    mkdir -p src/github.com/git-lfs; \
    mv git-lfs-* src/github.com/git-lfs/git-lfs; \
    cd /tmp/docker_setup/src/github.com/git-lfs/git-lfs/rpm; \
    touch build.log; \
    tail -f build.log & GOPATH=/tmp/docker_setup ./build_rpms.bsh; \
    rm -rf /tmp/docker_setup

#Add the simple build repo script
COPY centos_script.bsh /tmp/

CMD /tmp/centos_script.bsh
