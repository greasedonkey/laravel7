# Base image from https://hub.docker.com/_/composer
FROM composer:1.10.5 as composer

WORKDIR /app

RUN composer global require hirak/prestissimo

COPY . /app

RUN composer install --no-dev

# Base image from https://hub.docker.com/_/php
FROM php:7.4-fpm

RUN apt-get update && apt-get install \
    libzip-dev \
    unzip \
    -y

RUN docker-php-ext-install bcmath zip

WORKDIR /app

COPY  --from=composer /app .

RUN chown -R www-data:www-data /app/storage
