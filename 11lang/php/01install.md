PHP 8.2 : Install
 	
Install PHP 8.2.

[1]	Install PHP 8.2.
```sh
root@belajarfreebsd:~# pkg install -y php82
Updating FreeBSD repository catalogue...
Fetching packagesite.pkg: 100%    7 MiB   2.4MB/s    00:03
Processing entries: 100%
FreeBSD repository update completed. 33723 packages processed.
All repositories are up to date.
The following 4 package(s) will be affected (of 0 checked):

New packages to be INSTALLED:
        libargon2: 20190702
        libxml2: 2.10.4_2
        pcre2: 10.42
        php82: 8.2.14

Number of packages to be installed: 4

The process will require 39 MiB more space.
7 MiB to be downloaded.

.....
.....

root@belajarfreebsd:~# php -v
PHP 8.2.14 (cli) (built: Jan  6 2024 01:47:15) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.2.14, Copyright (c) Zend Technologies

# verify to create test script
root@belajarfreebsd:~# echo '<?php echo `php -i`."\n"; ?>' > php_test.php
root@belajarfreebsd:~# php php_test.php
phpinfo()
PHP Version => 8.2.14

System => FreeBSD node01.belajarfreebsd.or.id 14.0-RELEASE FreeBSD 14.0-RELEASE #0 releng/14.0-n265380-f9716eee8ab4: Fri Nov 10 05:57:23 UTC 2023  root@releng1.nyi.freebsd.org:/usr/obj/usr/src/amd64.amd64/sys/GENERIC amd64
Build Date => Jan  6 2024 01:42:30
Build System => FreeBSD 140amd64-quarterly-job-11 14.0-RELEASE-p4 FreeBSD 14.0-RELEASE-p4 amd64
.....
.....
root@belajarfreebsd:~# pkg install php82-{mysqli,extensions} #option 
