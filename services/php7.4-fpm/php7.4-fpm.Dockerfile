FROM php:7.4-fpm
RUN apt-get update && apt-get install -y ssh
COPY services/php7.4-fpm/configs/php.ini "$PHP_INI_DIR/php.ini"
COPY services/php7.4-fpm/configs/php-fpm.conf "/usr/local/etc/php-fpm.conf"
COPY ssh/ssh.config "/root/.ssh/config"
COPY ssh/owner.id_rsa "/root/.ssh/vcs.id_rsa"
RUN chmod 600 /root/.ssh/vcs.id_rsa
RUN chmod 600 /root/.ssh/config
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN ssh-keyscan -t rsa gitlab.com >> ~/.ssh/known_hosts
RUN apt-get update && apt-get install -y \
      nano git bzip2 libbz2-dev libffi-dev zlib1g-dev libpng-dev libwebp-dev libjpeg-dev \
      libmagickwand-dev libmemcached-dev libxml2-dev libzip-dev libxslt-dev \
      zip unzip python-dev cmake \
    && docker-php-ext-install -j$(nproc) \
      bcmath bz2 calendar exif ffi gettext mysqli pcntl pdo_mysql \
      shmop soap sockets sysvmsg sysvsem sysvshm xsl zip opcache intl\
    && pecl install apcu-5.1.21 imagick-3.7.0 memcached-3.1.5 igbinary-3.2.7 xdebug-3.1.3 \
    && docker-php-ext-enable apcu imagick memcached igbinary xdebug
RUN docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg \
    && docker-php-ext-install gd
#composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer
EXPOSE 9000