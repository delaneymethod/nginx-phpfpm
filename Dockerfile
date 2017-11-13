FROM ubuntu:16.04

MAINTAINER Sean Delaney <hello@delaneymethod.com>

RUN apt-get update && apt-get install -y locales && locale-gen en_GB.UTF-8

ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

RUN apt-get update && apt-get install -y nginx curl zip unzip git software-properties-common supervisor sqlite3 && add-apt-repository -y ppa:ondrej/php && apt-get update && apt-get install -y php7.1-fpm php7.1-cli php7.1-mcrypt php7.1-gd php7.1-mysql php7.1-pgsql php7.1-imap php7.1-memcached php7.1-mbstring php7.1-imagick php7.1-xml php7.1-curl php7.1-sqlite3 php7.1-xdebug && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer && mkdir /run/php && apt-get remove -y --purge software-properties-common && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
        
COPY nginx.conf /etc/nginx/

COPY default /etc/nginx/sites-available/default

COPY php-fpm.conf /etc/php/7.1/fpm/php-fpm.conf

COPY www.conf /etc/php/7.1/fpm/pool.d/www.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
