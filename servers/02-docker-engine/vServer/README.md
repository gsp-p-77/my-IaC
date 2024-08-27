# Docker engine with portainer and SSL access via nginx

This repository holds the basic configuration setup of
my docker engine and its deployed services, e.g. my personal web page

## Usage, how I did the setup

## Provisioning
- Obtained a domain on domain factory
- vServer instance purchased from Cload provider (hetzner):
  - ubuntu-4gb-nbg1-2
  - Ubuntu 22.04 image
  - with ssh key, which I generated before
- Cloned this repo to the machine
- Automatic provisioning via provision.sh

## SSL certificate and NGINX

### Initial auto certificate
- Configure new sub domain vserver01.gsw7711.de with an A record to point to public IP address of vServer
- Copy nginx-obtain-certificate.conf to /etc/nginx/nginx.conf
```
cp nginx-obtain-certificate.conf /etc/nginx/nginx.conf
```
- Use Certbot to obtain a Let's Encrypt SSL certificate for domain and subdomain
```
sudo certbot certonly --nginx -d vserver01.gsw7711.de -d home.vserver01.gsw7711.de

### Final nginx config with certificates
```
- Copy final nginx conf
```
cp nginx.conf /etc/nginx/nginx.conf
```
- Restart nginx
```
sudo systemctl reload nginx
```

## Setup portainer

- Portainer should be accessible via https://vserver01.gsw7711.de
- Initial config: user name and password
- Build container image from web side https://github.com/gsp-p-77/GSwPersonalWebPage.git
- Create container from image and expose port 3000 for container port 3000

## Test web page
Web page should be accessible via https://home.vserver01.gsw7711.de


