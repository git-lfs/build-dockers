FROM centos:5
MAINTAINER Andy Neff <andyneff@users.noreply.github.com>

SOURCE centos_5.bootstrap

RUN rm -rf /tmp/docker_setup

#Add the simple build repo script
COPY rpm_sign.exp centos_script.bsh /tmp/

CMD /tmp/centos_script.bsh
