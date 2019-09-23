FROM php:7.3-alpine

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 	&& php composer-setup.php --install-dir=bin --filename=composer \
	&& php -r "unlink('composer-setup.php');" && composer -v