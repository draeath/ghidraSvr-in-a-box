FROM registry.access.redhat.com/ubi8/ubi
LABEL org.opencontainers.image.authors="Paul Bransford <draeath@gmail.com>"
LABEL org.opencontainers.image.title="ghidraSvr-in-a-box"
LABEL org.opencontainers.image.description "Yet another ghidra server container implementation."
LABEL org.opencontainers.image.version="10.1.2_PUBLIC_20220125"
LABEL org.opencontainers.image.revision="63bb30ac8bee0e3ff34c9812d751edcfdc70dbe4"
LABEL org.opencontainers.image.source="https://github.com/NationalSecurityAgency/ghidra"
LABEL org.opencontainers.image.url="https://github.com/draeath/ghidraSvr-in-a-box"
LABEL org.opencontainers.image.licenses="Apache-2.0"

ARG GHIDRASRV_IN_A_BOX_SHORTVERSION
ARG GHIDRASRV_IN_A_BOX_VERSION
ARG GHIDRASRV_IN_A_BOX_SHA256
ENV GHIDRASRV_IN_A_BOX_SHORTVERSION=${GHIDRASRV_IN_A_BOX_SHORTVERSION:-10.1.2}
ENV GHIDRASRV_IN_A_BOX_VERSION=${GHIDRASRV_IN_A_BOX_VERSION:-10.1.2_PUBLIC_20220125}
ENV GHIDRASRV_IN_A_BOX_SHA256=${GHIDRASRV_IN_A_BOX_SHA256:-ac96fbdde7f754e0eb9ed51db020e77208cdb12cf58c08657a2ab87cb2694940}

RUN dnf makecache &&\
    dnf upgrade -y &&\
    dnf install -y --allowerasing java-11-openjdk-headless wget unzip ca-certificates &&\
    dnf clean all

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
CMD ["/ghidra/container-entrypoint.sh"]
