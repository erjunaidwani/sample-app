FROM php:8.2-fpm-alpine

WORKDIR /app

# Install necessary PHP extensions and development headers
RUN apk add --no-cache --update freetype-dev libpng-dev libjpeg-turbo-dev

# Install GD extension with FreeType and JPEG support
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

# Install pdo and pdo_mysql
RUN docker-php-ext-install pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application files
COPY . /app

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose port 80
EXPOSE 80

# Set the entry point
CMD ["php", "-S", "0.0.0.0:80", "web/index.php"]
