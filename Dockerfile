FROM alpine:edge AS hints
RUN apk upgrade --no-cache && \
	apk add --no-cache ca-certificates curl && \
	curl -m 60 --connect-timeout 10 --retry 3 --retry-delay 10 "https://www.internic.net/domain/named.root" -o /tmp/root.hints


FROM alpine:edge
RUN apk upgrade --no-cache && \
	apk add --no-cache ca-certificates unbound drill && \
	mkdir -p /var/lib/unbound/ && \
	rm -rf /etc/unbound/*.conf /etc/unbound/conf.d/*.conf /etc/unbound/root.* /var/lib/unbound/root.* /var/cache/apk/* /tmp/* /var/tmp/* /var/log/*
COPY /etc/unbound/unbound.conf /etc/unbound/
COPY --from=hints /tmp/root.hints /var/lib/unbound/
RUN /usr/sbin/unbound-anchor -4 -r /var/lib/unbound/root.hints -a /var/lib/unbound/root.key ; true && \
	chown -R unbound:unbound /var/lib/unbound/
CMD ["/bin/nice", "-n", "-11", "/usr/sbin/unbound", "-c", "/etc/unbound/unbound.conf", "-d"]
