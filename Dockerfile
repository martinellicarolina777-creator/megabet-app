FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    libpq-dev

RUN docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

WORKDIR /var/www/html
COPY . /var/www/html

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs

ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -s "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/*.conf
RUN sed -ri -s "s!/var/www!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN chown -R www-data:www-data /var/www/html
RUN a2enmod rewrite

EXPOSE 80
