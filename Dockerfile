FROM alpine:latest as builder

ARG NEXUS_VERSION
ARG NEXUS_DOWNLOAD_URL=https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz

RUN wget --quiet --output-document=/tmp/nexus.tar.gz "${NEXUS_DOWNLOAD_URL}" && \
    mkdir /tmp/sonatype && \
    tar -zxf /tmp/nexus.tar.gz -C /tmp/sonatype && \
    mv /tmp/sonatype/nexus-${NEXUS_VERSION} /tmp/sonatype/nexus && \
    rm /tmp/nexus.tar.gz

FROM eclipse-temurin:8-jre

ENV SONATYPE_DIR=/opt/sonatype
ENV NEXUS_HOME=${SONATYPE_DIR}/nexus \
    NEXUS_DATA=/nexus-data \
    NEXUS_CONTEXT='' \
    SONATYPE_WORK=${SONATYPE_DIR}/sonatype-work

COPY --from=builder /tmp/sonatype /opt/sonatype
RUN mv ${SONATYPE_WORK}/nexus3 ${NEXUS_DATA} && \
    ln -s ${NEXUS_DATA} ${SONATYPE_WORK}/nexus3

RUN addgroup --system --gid 2001 nexus && \
    adduser --system --uid 2001 --disabled-password --no-create-home --group nexus
RUN chown -R nexus:nexus /nexus-data

RUN sed -i '/^-Xms/d;/^-Xmx/d;/^-XX:MaxDirectMemorySize/d' ${NEXUS_HOME}/bin/nexus.vmoptions
RUN sed -i -e 's/^nexus-context-path=\//nexus-context-path=\/\${NEXUS_CONTEXT}/g' ${NEXUS_HOME}/etc/nexus-default.properties

VOLUME ${NEXUS_DATA}

EXPOSE 8081
USER nexus

ENV INSTALL4J_ADD_VM_PARAMS="-Xms2703m -Xmx2703m -XX:MaxDirectMemorySize=2703m -Djava.util.prefs.userRoot=${NEXUS_DATA}/javaprefs"

CMD ["/opt/sonatype/nexus/bin/nexus", "run"]