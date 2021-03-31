FROM docker.io/library/debian:buster
LABEL org.opencontainers.image.authors="Paul Bransford <draeath@gmail.com>"
LABEL org.opencontainers.image.title="ghidraSvr-in-a-box"
LABEL org.opencontainers.image.description "Yet another ghidra server container implementation."
LABEL org.opencontainers.image.version="9.2.2_PUBLIC_20201229"
LABEL org.opencontainers.image.revision="cfaf865567f69194c24405660d7bdf4354e4dc38"
LABEL org.opencontainers.image.source="https://github.com/NationalSecurityAgency/ghidra"
LABEL org.opencontainers.image.url="https://github.com/draeath/ghidraSvr-in-a-box"
LABEL org.opencontainers.image.licenses="Apache-2.0"

ARG CORRETTO_URL=https://corretto.aws/downloads/resources/11.0.10.9.1/java-11-amazon-corretto-jdk_11.0.10.9-1_amd64.deb
ARG CORRETTO_FILE=java-11-amazon-corretto-jdk_11.0.10.9-1_amd64.deb
ARG CORRETTO_MD5=6e5a33117ef8cb771a7ef48b6fe97fc2

ARG GHIDRASRV_IN_A_BOX_VERSION
ARG GHIDRASRV_IN_A_BOX_SHA256
ENV GHIDRASRV_IN_A_BOX_VERSION=${GHIDRASRV_IN_A_BOX_VERSION:-9.2.2_PUBLIC_20201229}
ENV GHIDRASRV_IN_A_BOX_SHA256=${GHIDRASRV_IN_A_BOX_SHA256:-8cf8806dd5b8b7c7826f04fad8b86fc7e07ea380eae497f3035f8c974de72cf8}

RUN echo "set debconf/frontend noninteractive" | DEBIAN_FRONTEND=noninteractive debconf-communicate

RUN apt-get update &&\
    apt-get install -y apt-utils &&\
    apt-get dist-upgrade -y &&\
    apt-get install -y --no-install-recommends coreutils wget ca-certificates unzip

WORKDIR /root

RUN wget --no-verbose -O "${CORRETTO_FILE}" "${CORRETTO_URL}" &&\
    echo "${CORRETTO_MD5}  ${CORRETTO_FILE}" | tee "${CORRETTO_FILE}.md5" &&\
    md5sum -c "${CORRETTO_FILE}.md5" &&\
    apt-get install -y "./${CORRETTO_FILE}" &&\
    rm "${CORRETTO_FILE}"

WORKDIR /ghidra

RUN wget --no-verbose -O "ghidra_${GHIDRASRV_IN_A_BOX_VERSION}.zip" "https://ghidra-sre.org/ghidra_${GHIDRASRV_IN_A_BOX_VERSION}.zip" &&\
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
CMD ["/ghidra/container-entrypoint.sh"]
