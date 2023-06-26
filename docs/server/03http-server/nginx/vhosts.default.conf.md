```sh
######### /usr/local/etc/nginx/vhosts/default.conf

# limit the number of connections per single IP
limit_conn_zone $binary_remote_addr zone=conn_limit_per_ip:10m;

# limit the number of requests for a given session
limit_req_zone $binary_remote_addr zone=req_limit_per_ip:10m rate=5r/s;

server {
    limit_conn conn_limit_per_ip 10;
    limit_req zone=req_limit_per_ip burst=10 nodelay;
    
    listen       80 default_server;
    listen       [::]:80 default_server;
    
    server_name  localhost;
    location ~* \.(?:css|js|map|jpe?g|gif|png)$ { } # opsi load file
   
    location / {
        root   /usr/local/www/nginx;
        index  index.php index.html index.htm;
        autoindex on;
        try_files $uri $uri/ =404; 
    }

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/local/www/nginx-dist;
    }

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass  127.0.0.1:9000; # unix:/var/run/php-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $request_filename;
        include fastcgi_params;
    }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    location ~ /\.ht {
        deny  all;
    }
}