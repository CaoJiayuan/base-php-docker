FROM php:7.3-alpine

# install composer
RUN apk add --no-cache --update git\
	&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 	&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
	&& php -r "unlink('composer-setup.php');" && composer -v

COPY ./default.ini /usr/local/etc/php/conf.d/default.ini 