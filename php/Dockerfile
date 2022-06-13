FROM php:5.6-fpm

WORKDIR /var/www/softgrader

RUN if [ ! -z $http_proxy ]; then pear config-set http_proxy $http_proxy; fi

RUN apt-get update && apt-get install -y libmemcached-dev zlib1g-dev \
    zip \
    unzip \
    curl \
    && docker-php-ext-install mysqli \
    && pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PHP_INI_DIR /usr/local/etc/php
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN groupadd -g 1000 softgrader
RUN useradd -u 1000 -ms /bin/bash -g softgrader softgrader

COPY --chown=softgrader:softgrader . /var/www/softgrader

USER softgrader

ENV PHP_FCGI_MAX_REQUESTS=0

EXPOSE 9000

CMD ["php-fpm"]
