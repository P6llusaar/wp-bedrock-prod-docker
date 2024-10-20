#Build stage
FROM composer:latest as builder

ARG git_url

WORKDIR /app

COPY .ssh/known_hosts /root/.ssh/known_hosts
COPY .ssh/ssh_key /root/.ssh/ssh_key
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/ssh_key 

RUN eval "$(ssh-agent -s)" && \
    ssh-add /root/.ssh/ssh_key && \
    git clone "$git_url" bedrock

WORKDIR /app/bedrock 
RUN composer install



#Deploy stage
FROM wordpress:php8.2-apache

RUN rm -rf /var/www/html/wp-content

COPY apache.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html
COPY --from=builder /app/bedrock ./bedrock

COPY .htaccess /var/www/html/bedrock/web/.htaccess

RUN apt-get update && apt-get -y install default-mysql-client

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN adduser wpadmin && \
    usermod -aG www-data wpadmin



COPY tools/plugins/configure_smtp.php /var/www/html/bedrock/web/app/mu-plugins/configure_smtp.php

RUN chown -R www-data:www-data /var/www/html

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir /backup_temp
RUN chown wpadmin:wpadmin /backup_temp



ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]