FROM registry.access.redhat.com/ubi9/ubi
LABEL org.opencontainers.image.authors="Paul Bransford <draeath@gmail.com>"
LABEL org.opencontainers.image.title="ghidraSvr-in-a-box"
LABEL org.opencontainers.image.description "Yet another ghidra server container implementation."
LABEL org.opencontainers.image.version="10.2_PUBLIC_20221101"
LABEL org.opencontainers.image.revision="17884b878680e640dd5c30210736a1d062ae5ba2"
LABEL org.opencontainers.image.source="https://github.com/NationalSecurityAgency/ghidra"
LABEL org.opencontainers.image.url="https://github.com/draeath/ghidraSvr-in-a-box"
LABEL org.opencontainers.image.licenses="Apache-2.0"

ARG GHIDRASRV_IN_A_BOX_SHORTVERSION
ARG GHIDRASRV_IN_A_BOX_VERSION
ARG GHIDRASRV_IN_A_BOX_SHA256
ENV GHIDRASRV_IN_A_BOX_SHORTVERSION=${GHIDRASRV_IN_A_BOX_SHORTVERSION:-10.2}
ENV GHIDRASRV_IN_A_BOX_VERSION=${GHIDRASRV_IN_A_BOX_VERSION:-10.2_PUBLIC_20221101}
ENV GHIDRASRV_IN_A_BOX_SHA256=${GHIDRASRV_IN_A_BOX_SHA256:-a5163f50bd6ce725c4c8638f7505b64bb603ea6bfe3f7d9ed4e403236716f787}

# corretto.key from https://yum.corretto.aws/corretto.key 2022-06-29
ADD corretto.key /etc/pki/rpm-gpg/RPM-GPG-KEY-AWS-Corretto
ADD corretto.repo /etc/yum.repos.d/corretto.repo
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-AWS-Corretto &&\
    dnf makecache &&\
    dnf upgrade -y &&\
    dnf install -y --allowerasing wget unzip ca-certificates java-11-amazon-corretto-devel &&\
    dnf clean all
ENV JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto

# While UBI apparently includes systemd support, I'm unsure how to make use of it. Add Tini and use it instead.
#   https://github.com/krallin/tini#using-tini
#   https://github.com/krallin/tini#existing-entrypoint
# see the release page for supported architectures: https://github.com/krallin/tini/releases
# TINI_TYPE can be 'tini' or 'tini-static'
ARG TINI_VERSION=v0.19.0
ARG TINI_ARCH=amd64
ARG TINI_TYPE=tini
ARG TINI_SHA256=93dcc18adc78c65a028a84799ecf8ad40c936fdfc5f2a57b1acda5a8117fa82c
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/${TINI_TYPE}-${TINI_ARCH} /tini
RUN echo "${TINI_SHA256}  /tini" > /tini.sha256 &&\
    sha256sum -c /tini.sha256 && unlink /tini.sha256
RUN chmod 0755 /tini

WORKDIR /ghidra

RUN wget --no-verbose -O "ghidra_${GHIDRASRV_IN_A_BOX_VERSION}.zip" "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${GHIDRASRV_IN_A_BOX_SHORTVERSION}_build/ghidra_${GHIDRASRV_IN_A_BOX_VERSION}.zip" &&\
    echo "${GHIDRASRV_IN_A_BOX_SHA256}  ghidra_${GHIDRASRV_IN_A_BOX_VERSION}.zip" | tee "ghidra_${GHIDRASRV_IN_A_BOX_VERSION}.zip.sha256" &&\
    sha256sum -c "ghidra_${GHIDRASRV_IN_A_BOX_VERSION}.zip.sha256" &&\
    rm "ghidra_${GHIDRASRV_IN_A_BOX_VERSION}.zip.sha256" &&\
    unzip -q "ghidra_${GHIDRASRV_IN_A_BOX_VERSION}.zip" -x "*/server/server.conf" &&\
    ln -s "ghidra_$(echo "${GHIDRASRV_IN_A_BOX_VERSION}" | rev | cut -d'_' -f2- | rev)" ghidra &&\
    rm "ghidra_${GHIDRASRV_IN_A_BOX_VERSION}.zip"

RUN mkdir -pv /mnt/ghidra
RUN ln -sv /mnt/ghidra/server.conf "${PWD}/ghidra/server/server.conf"

ADD container-entrypoint.sh .
RUN chmod 0755 container-entrypoint.sh

EXPOSE 13100/tcp
EXPOSE 13101/tcp
EXPOSE 13102/tcp

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/ghidra/ghidra:/ghidra/ghidra/server"
WORKDIR /ghidra/ghidra/server
ENTRYPOINT ["/tini", "--"]
CMD ["/ghidra/container-entrypoint.sh"]
