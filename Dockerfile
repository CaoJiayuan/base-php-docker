
FROM php:7.3-alpine
RUN ls -l /usr/local/bin/

FROM docker:dind-rootless

COPY --from=0 /usr/local/bin/* /usr/local/bin/
COPY --from=0 /usr/local/lib/php/extensions/no-debug-non-zts-20180731/* /usr/local/lib/php/extensions/no-debug-non-zts-20180731/

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN mkdir -p /usr/local/lib/php/extensions/no-debug-non-zts-20180731 && mkdir -p /usr/local/etc/php \ && \
     apk add --no-cache curl libxml2 libedit argon2-dev


# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 	&& php composer-setup.php --install-dir=bin --filename=composer \
	&& php -r "unlink('composer-setup.php');" && composer -v