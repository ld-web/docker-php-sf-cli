FROM php:7.4-fpm AS php_default
RUN apt-get update && apt-get install -y --no-install-recommends git zlib1g-dev libzip-dev unzip libicu-dev libonig-dev
RUN mkdir /run/php
ADD conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
ADD conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN sed -i 's|memory_limit = 128M|memory_limit = 1024M|g' ${PHP_INI_DIR}/php.ini
RUN sed -i 's|upload_max_filesize = 2M|upload_max_filesize = 8M|g' ${PHP_INI_DIR}/php.ini
RUN sed -i 's|;realpath_cache_size = 4096k|realpath_cache_size = 4096k|g' ${PHP_INI_DIR}/php.ini
RUN sed -i 's|;realpath_cache_ttl = 120|realpath_cache_ttl = 600|g' ${PHP_INI_DIR}/php.ini
RUN sed -i 's|;opcache.preload_user=|opcache.preload_user=www-data|g' ${PHP_INI_DIR}/php.ini
RUN sed -i 's|;opcache.enable=1|opcache.enable=1|g' ${PHP_INI_DIR}/php.ini
RUN sed -i 's|;opcache.memory_consumption=128|opcache.memory_consumption=256|g' ${PHP_INI_DIR}/php.ini
RUN sed -i 's|;opcache.max_accelerated_files=10000|opcache.max_accelerated_files=20000|g' ${PHP_INI_DIR}/php.ini
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer
RUN ln -snf /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN docker-php-ext-install pdo_mysql \
  && docker-php-ext-install intl \
  && docker-php-ext-install zip
RUN docker-php-ext-configure opcache --enable-opcache \
  && docker-php-ext-install opcache
RUN apt-get install -y vim locate
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash
RUN apt install symfony-cli
RUN updatedb
WORKDIR /php
EXPOSE 9000

FROM php_default AS php_dev
RUN pecl install -f xdebug-2.9.8 \
  && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)\nxdebug.remote_enable=1\nxdebug.remote_autostart=1\nxdebug.remote_port=9002" > /usr/local/etc/php/conf.d/xdebug.ini;
RUN sed -i "s|;opcache.validate_timestamps=1|opcache.validate_timestamps=1|g" ${PHP_INI_DIR}/php.ini
RUN sed -i "s|;opcache.revalidate_freq=2|opcache.revalidate_freq=0|g" ${PHP_INI_DIR}/php.ini