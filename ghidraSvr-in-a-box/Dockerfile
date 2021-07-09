FROM docker.io/library/debian:buster
LABEL org.opencontainers.image.authors="Paul Bransford <draeath@gmail.com>"
LABEL org.opencontainers.image.title="ghidraSvr-in-a-box"
LABEL org.opencontainers.image.description "Yet another ghidra server container implementation."
LABEL org.opencontainers.image.version="9.2.4_PUBLIC_20210427"
LABEL org.opencontainers.image.revision="fbc8a6fb05d3a4ee9df19ed2dc5cdb98e4a402d9"
LABEL org.opencontainers.image.source="https://github.com/NationalSecurityAgency/ghidra"
LABEL org.opencontainers.image.url="https://github.com/draeath/ghidraSvr-in-a-box"
LABEL org.opencontainers.image.licenses="Apache-2.0"

ARG GHIDRASRV_IN_A_BOX_VERSION
ARG GHIDRASRV_IN_A_BOX_SHA256
ENV GHIDRASRV_IN_A_BOX_VERSION=${GHIDRASRV_IN_A_BOX_VERSION:-9.2.4_PUBLIC_20210427}
ENV GHIDRASRV_IN_A_BOX_SHA256=${GHIDRASRV_IN_A_BOX_SHA256:-c1f18cdb12e2e1c0313e7becf7f0387226937ac67ad6c6e5056fa889229f969a}

RUN echo "set debconf/frontend noninteractive" | DEBIAN_FRONTEND=noninteractive debconf-communicate

RUN apt-get update &&\
    apt-get install -y apt-utils &&\
    apt-get dist-upgrade -y &&\
    apt-get install -y --no-install-recommends coreutils wget ca-certificates unzip openjdk-11-jdk-headless

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
