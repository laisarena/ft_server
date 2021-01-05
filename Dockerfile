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

RUN wget https://wordpress.org/latest.tar.gz && tar -xzvf latest.tar.gz

COPY srcs/default /etc/nginx/sites-available/default

#RUN ln -s /etc/nginx/sites-available/default2 /etc/nginx/sites-enabled/

ENTRYPOINT	service nginx start && \
			service php7.3-fpm start && \
			tail -f /dev/null
