1. Buka dan Edit file di | edit /usr/local/etc/apache24/httpd.conf

  ```sh
  ...
  LoadModule rewrite_module libexec/apache24/mod_rewrite.so
  LoadModule php7_module        libexec/apache24/libphp7.so

  <IfModule dir_module>
      DirectoryIndex index.php index.html
      <FilesMatch "\.php$">
          SetHandler application/x-httpd-php
      </FilesMatch>
      <FilesMatch "\.phps$">
          SetHandler application/x-httpd-php-source
      </FilesMatch>
  </IfModule>

  <IfModule mime_module>
      ...
      AddType application/x-httpd-php .php
      AddType application/x-httpd-php-source .phps
  </IfModule>
  ```
 <b>test</b>
 ```
 apachectl configtest
 ```

2. Buat file phpinfo.php di | edit /usr/local/www/apache24/data/phpinfo.php
```sh
<?php phpinfo();
```
3. Salin file php.ini-production di /usr/local/etc/php.ini-production menjadi salinan php.ini
```sh
cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
rehash
```
4. Konfigurasi dasar file php.ini | edit /usr/local/etc/php.ini
```sh
[Date]
date.timezone = Asia/Jakarta
[Session]
session.save_handler = files
session.save_path = "/tmp"
```
