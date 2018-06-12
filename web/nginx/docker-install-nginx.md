# docker 安装nginx

## https://docs.docker.com/samples/library/nginx

docker run --name aniu-nginx -d -p 80:80 -p 443:443 -v /data/nginx_home/html:/usr/share/nginx/html -v /data/nginx_home/nginx.conf:/etc/nginx/nginx.conf -v /data/nginx_home/logs:/var/log/nginx -v /data/nginx_home/vhost:/etc/nginx/conf.d -v /data/nginx_home/ssl:/etc/nginx/ssl -u 0 nginx


# 自颁证书
openssl x509 -in dev.jenkins.aniu.so.csr -out dev.jenkins.aniu.so.crt -req -signkey dev.jenkins.aniu.so.key -days 3650
