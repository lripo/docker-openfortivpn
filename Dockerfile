ARG BASE_IMAGE="ubuntu:20.04"
#ARG BASE_IMAGE="ubuntu:22.04"

FROM ${BASE_IMAGE} as builder
# Build glider
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

FROM ${BASE_IMAGE}
ARG debug="yes"
RUN apt-get update && \
  apt-get install -y openfortivpn dnsmasq

RUN if [ ! -z "$debug" ]; then \
  apt-get install -y dnsutils iputils-ping curl wget netcat openssh-client iproute2 tcpdump telnet traceroute net-tools strace ;\
fi

# Buff... libdrm-dev ffmpeg
#COPY files/forticlient_7.0.3.0137_amd64.deb /
#RUN apt-get install -y /forticlient_7.0.3.0137_amd64.deb

RUN rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/bin/glider /usr/bin
RUN chown root:root /usr/bin/glider && chmod +x /usr/bin/glider

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

RUN echo "port=53\nlog-queries\n" > /etc/dnsmasq.conf
RUN echo "pkill -9 dnsmasq; sleep 2; dnsmasq" >> /etc/ppp/ip-up.local && chmod +x /etc/ppp/ip-up.local

EXPOSE 8080
EXPOSE 53
ENV GLIDER_VERBOSE=true
ENV CONFIG_FILE=/etc/openfortivpn/config

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD openfortivpn -c $CONFIG_FILE
