1. Buka dan Edit file di /usr/local/etc/apache24/httpd.conf
  ```sh
  ee /usr/local/etc/apache24/httpd.conf
  ```

  ```sh
  # Step 1 added
  LoadModule rewrite_module libexec/apache24/mod_rewrite.so
  LoadModule php7_module        libexec/apache24/libphp7.so

  # Step 2 added
  # DirectoryIndex: sets the file that Apache will serve if a directory
  # is requested.
  #
  <IfModule dir_module>
      DirectoryIndex index.php index.html
  </IfModule>

  # Step 3 added
  # AddType allows you to add to or override the MIME configuration
  # file specified in TypesConfig for specific file types.
  #
  #AddType application/x-gzip .tgz
  #
  # AddEncoding allows you to have certain browsers uncompress
  # information on the fly. Note: Not all browsers support this.
  #
  #AddEncoding x-compress .Z
  #AddEncoding x-gzip .gz .tgz
  #
  # If the AddEncoding directives above are commented-out, then you
  # probably should define those extensions to indicate media types:
  #
  AddType application/x-compress .Z
  AddType application/x-gzip .gz .tgz
  AddType application/x-httpd-php .php
  AddType application/x-httpd-php-source .phps
  ```

2. Buat file phpinfo.php di /usr/local/www/apache24/data/phpinfo.php
```sh
ee /usr/local/www/apache24/data/phpinfo.php
```
```sh
<?php phpinfo();
```
3. Salin file php.ini-production di /usr/local/etc/php.ini-production menjadi salinan php.ini
```sh
cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
```
4. Konfigurasi dasar file php.ini
```sh
ee /usr/local/etc/php.ini
```

```sh
[Date]
date.timezone = Asia/Jakarta

[Session]
session.save_handler = files
session.save_path = "/tmp"
```
