# nginx-early-data-docker

docker run example

```
docker run -v /path/to/crt/and/key:/tmp -p 4433:4433 -it nginx-early-data nginx -g "daemon off;" -c /etc/nginx/nginx.conf
```
