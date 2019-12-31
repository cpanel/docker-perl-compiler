FROM centos:7

ADD . /build-perl/
#ADD patches /build-perl/patches
#COPY entrypoint.sh /entrypoint.sh

WORKDIR /build-perl

#RUN yum install -y git
RUN yum install -y make gcc patch less which libidn libidn-devel openssl openssl-devel expat expat-devel

VOLUME [ "/build-perl" ]

RUN /build-perl/build-perl.sh
#CMD ["/build-perl/build-perl.sh"]

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/build-perl/entrypoint.sh"]
