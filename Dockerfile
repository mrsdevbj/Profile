FROM dunglas/frankenphp:latest

# Installation des extensions PHP nécessaires
RUN install-php-extensions intl opcache zip

# Récupération de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . /app

# Autoriser Composer à s'exécuter en root
ENV COMPOSER_ALLOW_SUPERUSER=1

# ÉTAPE CORRIGÉE : Ajout de --no-scripts pour éviter les plantages de cache en build
RUN composer install --no-dev --optimize-autoloader --no-scripts

ENV FRANKENPHP_CONFIG="document_root ./public"
