```sh
######### /usr/local/etc/nginx/vhosts/default.conf

# limit the number of connections per single IP
limit_conn_zone $binary_remote_addr zone=conn_limit_per_ip:10m;
# limit the number of requests for a given session
limit_req_zone $binary_remote_addr zone=req_limit_per_ip:10m rate=5r/s;

server {
    limit_conn conn_limit_per_ip 10;
    limit_req zone=req_limit_per_ip burst=10 nodelay;
        
    listen       80;
    server_name  localhost;

    root   /usr/local/www/nginx;
    index  index.php index.html index.htm;

    #charset koi8-r;

    #access_log  logs/host.access.log  main;
    access_log off;

    location ~* \.(?:css|js|map|jpe?g|ico|gif|png)$ { 
        expires 30d;
        add_header Cache-Control "public, no-transform";
    } 

    # opsi load file
    location / {
        autoindex on;
        try_files $uri $uri/ =404; 
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/local/www/nginx-dist;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass   unix:/var/run/php-fpm.sock;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $request_filename;
        include        fastcgi_params;
    }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    location ~ /\.ht {
        deny  all;
    }
}