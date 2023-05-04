Message from php82-pdo-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-pdo.ini
=====
Message from php82-dom-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-dom.ini
=====
Message from php82-session-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-18-session.ini
=====
Message from php82-xmlwriter-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-xmlwriter.ini
=====
Message from php82-posix-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-posix.ini
=====
Message from php82-sqlite3-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-sqlite3.ini
=====
Message from php82-tokenizer-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-tokenizer.ini
=====
Message from php82-xmlreader-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-30-xmlreader.ini
=====
Message from php82-ctype-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-ctype.ini
=====
Message from php82-xml-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-xml.ini
=====
Message from php82-simplexml-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-simplexml.ini
=====
Message from php82-iconv-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-iconv.ini
=====
Message from php82-phar-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-phar.ini
=====
Message from php82-opcache-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-10-opcache.ini
=====
Message from php82-filter-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-filter.ini
=====
Message from php82-pdo_sqlite-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-30-pdo_sqlite.ini
=====
Message from php82-mysqli-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-mysqli.ini
=====
Message from mod_php82-8.2.5:

--
******************************************************************************

Make sure index.php is part of your DirectoryIndex.

You should add the following to your Apache configuration file:

<FilesMatch "\.php$">
    SetHandler application/x-httpd-php
</FilesMatch>
<FilesMatch "\.phps$">
    SetHandler application/x-httpd-php-source
</FilesMatch>

******************************************************************************

If you are building PHP-based ports in poudriere(8) or Synth with ZTS enabled,
add WITH_MPM=event to /etc/make.conf to prevent build failures.

******************************************************************************