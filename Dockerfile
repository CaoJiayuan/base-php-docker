FROM php:7.3.9-alpine3.10

# with composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/bin --filename=composer\
    && php -r "unlink('composer-setup.php');"

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#runtime-dependencies
RUN set -eux; \
	apk add --no-cache \
		btrfs-progs \
		e2fsprogs \
		e2fsprogs-extra \
		iptables \
		openssl \
		shadow-uidmap \
		xfsprogs \
		xz \
# pigz: https://github.com/moby/moby/pull/35697 (faster gzip implementation)
		pigz \
	; \
# only install zfs if it's available for the current architecture
# https://git.alpinelinux.org/cgit/aports/tree/main/zfs/APKBUILD?h=3.6-stable#n9 ("all !armhf !ppc64le" as of 2017-11-01)
# "apk info XYZ" exits with a zero exit code but no output when the package exists but not for this arch
	if zfs="$(apk info --no-cache --quiet zfs)" && [ -n "$zfs" ]; then \
		apk add --no-cache zfs; \
	fi

# set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
RUN set -x \
	&& addgroup -S dockremap \
	&& adduser -S -G dockremap dockremap \
	&& echo 'dockremap:165536:65536' >> /etc/subuid \
	&& echo 'dockremap:165536:65536' >> /etc/subgid

# https://github.com/docker/docker/tree/master/hack/dind
ENV DIND_COMMIT %%DIND-COMMIT%%

RUN set -eux; \
	wget -O /usr/local/bin/dind "https://raw.githubusercontent.com/docker/docker/master/hack/dind"; \
	chmod +x /usr/local/bin/dind

COPY dockerd-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

VOLUME /var/lib/docker
EXPOSE 2375 2376

ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD []