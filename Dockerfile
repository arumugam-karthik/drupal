# Use an official PHP-FPM image as the base with PHP 8.3
FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
    zip unzip \
    git \
    curl \
    vim \
    nginx \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip opcache \
    && docker-php-ext-enable opcache

# Set the working directory
WORKDIR /var/www/html

# Copy the application source code
COPY . /var/www/html

# Set correct permissions for Drupal
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Copy Nginx configuration
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Expose ports
EXPOSE 80

# Start Nginx and PHP-FPM
CMD ["sh", "-c", "nginx && php-fpm"]