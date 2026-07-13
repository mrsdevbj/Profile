FROM dunglas/frankenphp:latest

# Installation des extensions nécessaires pour Symfony
RUN install-php-extensions intl opcache zip

# Copie de ton projet dans le serveur
COPY . /app

# Installation des composants en mode Production
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --no-dev --optimize-autoloader

# Commande pour compiler ton design Tailwind CSS
RUN php bin/console tailwind:build

# Définition du dossier public officiel de Symfony
ENV FRANKENPHP_CONFIG="document_root ./public"
