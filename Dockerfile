FROM centos:7

MAINTAINER keepwalking86

#Set timezone Asia/Ho_Chi_Minh
ENV TZ='Asia/Ho_Chi_Minh'
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Installing repo epel, webstatic
RUN yum -y install epel-release && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

#Installing PHP7
RUN yum -y install php72w php72w-gd php72w-phar \
    php72w-xml php72w-cli php72w-mbstring php72w-tokenizer \
    php72w-openssl php72w-pdo php72w-opcache php72w-pear \
    php72w-fpm php72w-mysql

#Setting PHP7
RUN sed -i 's/;date.timezone =/date.timezone = Asia\/Ho_Chi_Minh/' /etc/php.ini
RUN sed -i 's/memory_limit\ =\ 128M/memory_limit\ =\ 2G/g' /etc/php.ini
RUN sed -i 's/upload_max_filesize\ =\ 2M/upload_max_filesize\ =\ 200M/g' /etc/php.ini
RUN sed -i 's/post_max_size\ =\ 8M/post_max_size\ =\ 400M/g' /etc/php.ini
RUN sed -i 's/max_execution_time\ =\ 30/max_execution_time\ =\ 300/g' /etc/php.ini

#Apply PHP configuration
COPY etc/www.conf /etc/php-fpm.d/
COPY etc/opcache.ini /etc/php.d/

###Installing & Configuring Nginx
RUN yum install -y nginx
COPY etc/nginx.conf /etc/nginx/

#Change nginx uid & gid
RUN usermod -u 1000 nginx && groupmod -g 1000 nginx

#Configure vhost
RUN mkdir /etc/nginx/sites-enabled

#Installing & Configuring Supervisord
RUN yum -y install python-setuptools
RUN easy_install supervisor
COPY etc/supervisord.conf /etc/supervisord.conf
# Set the default command to execute
CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]

##Clearing the yum Caches
RUN yum clean all

## Expose ports
EXPOSE 80 9000
