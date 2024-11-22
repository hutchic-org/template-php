# Use an official PHP image with Apache
FROM php:8.4-apache

# Arguments to be passed at build time
ARG UID=1000
ARG GID=1000

# Install system dependencies for Composer and required PHP extensions
RUN apt-get update && apt-get install -y \
        git \
        unzip \
        libzip-dev \
        zip \
    && docker-php-ext-install zip pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create a group and user with host's UID/GID
RUN groupadd -g $GID appuser && \
    useradd -u $UID -g appuser -m appuser

# Change ownership of the web root and logs to the new user
RUN chown -R appuser:appuser /var/www /var/log/apache2

# Switch to the new user
USER appuser

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the application source code
COPY --chown=appuser:appuser . .

# Use Composer to install PHP dependencies
RUN composer install --no-interaction --optimize-autoloader --no-dev
