# Docker for Nginx PHP72 from CentOS base image

## Build the docker image

`docker build -t keepwalking/nginx-php72 .`

## Running the docker container for example site

`docker run -d -p 8081:80 -v `pwd`/sites-enabled:/etc/nginx/sites-enabled -v `pwd`/app:/var/www/html --name nginx-php72 keepwalking86/nginx-php72`