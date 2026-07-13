FROM dunglas/frankenphp:latest

# Installation des extensions PHP nécessaires
RUN install-php-extensions intl opcache zip

# Récupération de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . /app

# Autoriser Composer à s'exécuter en root
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --no-dev --optimize-autoloader

ENV FRANKENPHP_CONFIG="document_root ./public"
