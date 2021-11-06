FROM alpine:3.14 AS hints

RUN apk add -v --no-cache curl && \
	curl -4L -m 60 --connect-timeout 10 --retry 3 --retry-delay 10 "https://www.internic.net/domain/named.root" -o /tmp/root.hints


FROM alpine:3.14

RUN apk upgrade -v --no-cache && \
	apk add -v --no-cache unbound drill && \
	mkdir -p /var/lib/unbound/ && \
	rm -rf /etc/unbound/*.conf /etc/unbound/conf.d/*.conf /etc/unbound/root.* /var/lib/unbound/root.* /var/cache/apk/* /tmp/* /var/tmp/* /var/log/*

COPY /etc/unbound/unbound.conf /etc/unbound/
COPY --from=hints /tmp/root.hints /var/lib/unbound/

RUN /usr/sbin/unbound-anchor -4v -r /var/lib/unbound/root.hints -a /var/lib/unbound/root.key ; true && \
	chown -R unbound:unbound /var/lib/unbound/

HEALTHCHECK --interval=5m --timeout=10s --start-period=10s --retries=3 CMD drill -4D -p 8353 cloudflare.com @127.0.0.1 | egrep -q 'flags:[a-z ]*ad{1}.*;' || exit 1

CMD ["/usr/sbin/unbound", "-c", "/etc/unbound/unbound.conf", "-d"]
