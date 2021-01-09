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

COPY srcs/default /etc/nginx/sites-available/default

RUN service mysql start && \
	mysql -u root --execute="CREATE DATABASE database_name; \
					CREATE USER 'lfrasson'@'localhost' IDENTIFIED BY 'senha'; \
					GRANT ALL PRIVILEGES ON wordpress.* TO 'lfrasson'@'localhost';"	

#RUN ln -s /etc/nginx/sites-available/default2 /etc/nginx/sites-enabled/

ENTRYPOINT	service nginx start && \
			service php7.3-fpm start && \
			tail -f /dev/null
