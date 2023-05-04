## Tambahkan file modul bahasa program yang sudah terinstal ke etc/apache24/modules.d
000_mod-php.conf
```conf
<IfModule dir_module>
    DirectoryIndex index.php index.html
    <FilesMatch "\.php$">
        SetHandler application/x-httpd-php
    </FilesMatch>
    <FilesMatch "\.phps$">
        SetHandler application/x-httpd-php-source
    </FilesMatch>
</IfModule>
```

Ketika sudah menambahn atau konfigurasi lakukan konfirmasi dengan:
```sh term
apachectl configtest
```
## Restart Apache
