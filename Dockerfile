FROM php:8.2-apache

# Installation des extensions PHP nécessaires pour Symfony
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    zip \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl opcache zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Activation du module Apache rewrite (indispensable pour Symfony)
RUN a2enmod rewrite

# Configuration du dossier public de Symfony comme racine d'Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

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

# Port standard écouté par Apache
EXPOSE 80
