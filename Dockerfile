FROM dunglas/frankenphp:latest

# Installation des extensions PHP nécessaires
RUN install-php-extensions intl opcache zip

# Récupération de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Définir le dossier de travail avant de copier
WORKDIR /app

# Copier les fichiers du projet
COPY . /app

# CORRECTION DE L'ERREUR 126 : Donner les bons droits d'exécution à l'utilisateur FrankenPHP
RUN chown -R www-data:www-data /app && chmod -R 755 /app

# Autoriser Composer à s'exécuter en root pour l'installation
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --no-dev --optimize-autoloader --no-scripts

ENV FRANKENPHP_CONFIG="document_root ./public"
