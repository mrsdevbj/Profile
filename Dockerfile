FROM php:8.2-apache

# Installation des dépendances et de l'extension pdo_pgsql pour Aiven PostgreSQL
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    libpq-dev \
    zip \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl opcache zip pdo_pgsql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Activation du module Apache rewrite
RUN a2enmod rewrite

# Configuration du dossier public de Symfony comme racine d'Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Configuration dynamique du port d'Apache pour Railway lors du build
RUN sed -s -i 's/Listen 80/Listen ${PORT}/g' /etc/apache2/ports.conf
RUN sed -s -i 's/<VirtualHost \*:80>/<VirtualHost \*:${PORT}>/g' /etc/apache2/sites-available/*.conf

# Installation de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Définition du répertoire de travail
WORKDIR /var/www/html

# Copie des fichiers du projet
COPY . /var/www/html

# Autoriser Composer à s'exécuter en root
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Attribution des droits à l'utilisateur Apache
RUN chown -R www-data:www-data /var/www/html

# Commande finale simplifiée et sécurisée au démarrage
CMD ["sh", "-c", "php bin/console cache:clear --no-interaction; php bin/console doctrine:migrations:migrate --no-interaction; apache2-foreground"]
