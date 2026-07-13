FROM dunglas/frankenphp:latest

RUN install-php-extensions intl opcache zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . /app

ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --no-dev --optimize-autoloader

RUN php bin/console tailwind:build

ENV FRANKENPHP_CONFIG="document_root ./public"
