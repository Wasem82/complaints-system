FROM php:8.2-cli

WORKDIR /var/www

# تثبيت الحزم المطلوبة
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev zip libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql zip

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# نسخ المشروع
COPY . .

# تثبيت Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# تنظيف الكاش
RUN php artisan config:clear
RUN php artisan route:clear
RUN php artisan view:clear

EXPOSE 8000

CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=$PORT

