#Get Composer
FROM composer:2.0 as vendor

WORKDIR /app

COPY database/ database/
COPY composer.json composer.json
COPY composer.lock composer.lock

RUN composer install \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --no-dev \
    --prefer-dist
    
COPY . .
RUN composer dump-autoload

FROM php:8.0.0rc1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y git zip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql

# Get latest Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www