```sh
######### /usr/local/etc/nginx/vhosts/default.conf

limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s; # opsi membatasi jumlah permintaan

server {
    listen       80 localhost;
    listen       [::]:80 localhost;
    
    server_name  localhost;
    location ~* \.(?:css|js|map|jpe?g|gif|png)$ { }
    return 301 https://$server_name$request_uri;
}

server {
    listen       443 ssl http2 localhost;
    listen       [::]:443 ssl http2 default_server;

    server_name  localhost;
    location ~* \.(?:css|js|map|jpe?g|gif|png)$ { } # opsi load file
    ssl_certificate      /usr/local/etc/ssl/certificate.crt;
    ssl_certificate_key  /usr/local/etc/ssl/private.key;
    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  5m;
    
    # Opsional: Konfigurasi SSL tambahan
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';
    ssl_prefer_server_ciphers  on;

    root   /usr/local/www/nginx;
    index  index.php index.html index.htm;   

    location / {
        autoindex on;
        limit_req zone=one burst=20 nodelay; # opsi membatasi jumlah permintaan
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
        fastcgi_pass unix:/var/run/php-fpm.sock;
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