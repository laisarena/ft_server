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

RUN mkdir /var/www/ft-server && \
	wget https://wordpress.org/latest.tar.gz && \
	tar -xzvf latest.tar.gz && \
	wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz && \
	tar -xzvf phpMyAdmin-latest-all-languages.tar.gz && \
	mv wordpress /var/www/ft-server/wordpress && \
	mv phpMyAdmin-5.0.4-all-languages /var/www/ft-server/phpMyAdmin

COPY srcs/ /

RUN mv /wp-config.php /var/www/ft-server/wordpress/wp-config.php && \
	mv /default /etc/nginx/sites-available/default && \
	mv /ft-server /etc/nginx/sites-available/ft-server && \
	ln -s /etc/nginx/sites-available/ft-server /etc/nginx/sites-enabled/

RUN service mysql start && \
	mysql -u root --execute="CREATE DATABASE wordpress; \
					CREATE USER 'lfrasson'@'localhost' IDENTIFIED BY 'senha'; \
					GRANT ALL PRIVILEGES ON wordpress.* TO 'lfrasson'@'localhost';"	&& \
	mysql wordpress < wordpress.sql

RUN openssl req -new -nodes -x509 \
	-newkey rsa:2048 \
	-keyout /etc/ssl/ftserver.key \
	-out /etc/ssl/ftserver.crt \
	-subj "/C=BR/ST=Sao Paulo/L=Sao Paulo"

ENV AUTO_INDEX on

ENTRYPOINT	sed -i "s/AUTO_INDEX/$AUTO_INDEX/g" /etc/nginx/sites-available/default && \
			service nginx start && \
			service php7.3-fpm start && \
			service mysql start && \
			tail -f /dev/null
