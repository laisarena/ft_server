FROM debian:buster

WORKDIR /

RUN	apt update && apt install -y  \
	wget \
	nginx \
	mariadb-server \
	php \
	php-fpm \
	php-opcache \
	php-cli \
	php-gd \
	php-curl \
	php-mysql \
	php-mbstring

RUN cd /var/www/html && \
	wget https://wordpress.org/latest.tar.gz && \
	tar -xzvf latest.tar.gz && \
	wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz && \
	tar -xzvf phpMyAdmin-latest-all-languages.tar.gz

COPY srcs/wp-config.php /var/www/html/wordpress/wp-config.php 

COPY srcs/default /etc/nginx/sites-available/default

RUN service mysql start && \
	mysql -u root --execute="CREATE DATABASE wordpress; \
					CREATE USER 'lfrasson'@'localhost' IDENTIFIED BY 'senha'; \
					GRANT ALL PRIVILEGES ON wordpress.* TO 'lfrasson'@'localhost';"	

ENV AUTO_INDEX on

ENTRYPOINT	sed -i "s/AUTO_INDEX/$AUTO_INDEX/g" /etc/nginx/sites-available/default && \
			service nginx start && \
			service php7.3-fpm start && \
			service mysql start && \
			tail -f /dev/null
