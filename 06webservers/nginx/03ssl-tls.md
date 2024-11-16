Nginx : SSL/TLS Setting2024/02/13
 	
Enable SSL/TLS setting to use secure encrypted connection.

[1]	Get SSL certificates, refer to here.

[2]	Configure Nginx. For example, enable SSL/TLS on default site.
```sh
root@www:~# vi /usr/local/etc/nginx/nginx.conf
http {
.....
.....
    # add settings in [http] section
    # replace servername and path of certificates to your own environment
    server {
        listen       443 ssl http2;
        listen       [::]:443 ssl http2;
        server_name  www.srv.world;
        root         /usr/local/www/nginx;

        ssl_certificate "/usr/local/etc/letsencrypt/live/www.srv.world/fullchain.pem";
        ssl_certificate_key "/usr/local/etc/letsencrypt/live/www.srv.world/privkey.pem";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  5m;
        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;
        location / {
            index  index.html index.htm;
        }
    }
}

root@www:~# service nginx reload
```
[3]	If you'd like to set HTTP connection to redirect to HTTPS (Always on SSL/TLS), configure like follows.
```sh
root@www:~# vi /usr/local/etc/nginx/nginx.conf
# add the line in the section that listens 80 port
    server {
        listen       80;
        return 301 https://$host$request_uri;

root@www:~# service nginx reload
```
[4]	Verify to access to the test page from a client computer with Web browser via HTTPS. If you set Always On SSL/TLS, access with HTTP to verify the connection is redirected to HTTPS normally, too.
