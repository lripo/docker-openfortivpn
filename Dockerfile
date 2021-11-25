ARG BASE_IMAGE="ubuntu:20.04"

FROM ${BASE_IMAGE} as builder
ARG GLIDER_VERSION="0.15.0"
ARG GLIDER_BASENAME="glider_${GLIDER_VERSION}_linux_amd64"
ARG GLIDER_ASSET_URL="https://github.com/nadoo/glider/releases/download/v${GLIDER_VERSION}/${GLIDER_BASENAME}.tar.gz"
WORKDIR /root
RUN echo "Building with glider version: $GLIDER_VERSION"
RUN apt-get update && apt-get install -y wget && \
   echo "URL: ${GLIDER_ASSET_URL}" && \
   wget "${GLIDER_ASSET_URL}" && \
   tar zxvf "${GLIDER_BASENAME}.tar.gz" "${GLIDER_BASENAME}"/glider && \
   cp ${GLIDER_BASENAME}"/glider" /usr/bin


FROM ubuntu:20.04

RUN apt-get update && \
  apt-get install -y openfortivpn && \
# Debug stuff
#  apt-get install -y dnsutils iputils-ping curl wget netcat openssh-client && \
  rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/bin/glider /usr/bin
RUN chown root:root /usr/bin/glider && chmod +x /usr/bin/glider

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8080
ENV GLIDER_VERBOSE=true
ENV CONFIG_FILE=/etc/openfortivpn/config

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD openfortivpn -c $CONFIG_FILE
