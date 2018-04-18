FROM resin/armhf-alpine:3.7
LABEL maintainer="swestcott@gmail.com"

ENV VERSION 0.12.0

RUN ["cross-build-start"]

ADD https://github.com/prometheus/blackbox_exporter/releases/download/v${VERSION}/blackbox_exporter-${VERSION}.linux-armv7.tar.gz /tmp/
#COPY blackbox_exporter-${VERSION}.linux-armv7.tar.gz /tmp/

RUN apk --update --no-cache upgrade \
	&& cd /tmp \
	&& tar -zxvf /tmp/blackbox_exporter-${VERSION}.linux-armv7.tar.gz \
	&& mkdir /etc/blackbox_exporter \
	&& cp -r /tmp/blackbox_exporter-${VERSION}.linux-armv7/blackbox_exporter /bin/blackbox_exporter \
	&& cp -r /tmp/blackbox_exporter-${VERSION}.linux-armv7/blackbox.yml /etc/blackbox_exporter/config.yml \
	&& rm -r /tmp/blackbox_exporter* \
	&& rm -r /var/cache/apk/*

RUN ["cross-build-end"]

EXPOSE 9115
ENTRYPOINT  [ "/bin/blackbox_exporter" ]
CMD [ "--config.file=/etc/blackbox_exporter/config.yml" ]
