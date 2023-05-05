Message from freetype2-2.12.1_2:

--
The 2.7.x series now uses the new subpixel hinting mode (V40 port's option) as
the default, emulating a modern version of ClearType. This change inevitably
leads to different rendering results, and you might change port's options to
adapt it to your taste (or use the new "FREETYPE_PROPERTIES" environment
variable).

The environment variable "FREETYPE_PROPERTIES" can be used to control the
driver properties. Example:

FREETYPE_PROPERTIES=truetype:interpreter-version=35 \
        cff:no-stem-darkening=1 \
        autofitter:warping=1

This allows to select, say, the subpixel hinting mode at runtime for a given
application.

If LONG_PCF_NAMES port's option was enabled, the PCF family names may include
the foundry and information whether they contain wide characters. For example,
"Sony Fixed" or "Misc Fixed Wide", instead of "Fixed". This can be disabled at
run time with using pcf:no-long-family-names property, if needed. Example:

FREETYPE_PROPERTIES=pcf:no-long-family-names=1

How to recreate fontconfig cache with using such environment variable,
if needed:
# env FREETYPE_PROPERTIES=pcf:no-long-family-names=1 fc-cache -fsv

The controllable properties are listed in the section "Controlling FreeType
Modules" in the reference's table of contents
(/usr/local/share/doc/freetype2/reference/index.html, if documentation was installed).
=====
Message from php82-zip-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-zip.ini
=====
Message from php82-gd-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-gd.ini
=====
Message from php82-zlib-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-zlib.ini
=====
Message from php82-bz2-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-bz2.ini
=====
Message from php82-mbstring-8.2.5:

--
This file has been added to automatically load the installed extension:
/usr/local/etc/php/ext-20-mbstring.ini
=====
Message from phpMyAdmin-php82-4.9.11_1:

--
phpMyAdmin-php82-4.9.11_1 has been installed into:

    /usr/local/www/phpMyAdmin

Please edit config.inc.php to suit your needs.

To make phpMyAdmin available through your web site, I suggest
that you add something like the following to httpd.conf:

Alias /phpmyadmin/ "/usr/local/www/phpMyAdmin/"

<Directory "/usr/local/www/phpMyAdmin/">
        Options None
        AllowOverride Limit

        Require local
        Require host .example.com
</Directory>

SECURITY NOTE: phpMyAdmin is an administrative tool that has had several
remote vulnerabilities discovered in the past, some allowing remote
attackers to execute arbitrary code with the web server's user credential.
All known problems have been fixed, but the FreeBSD Security Team strongly
advises that any instance be protected with an additional protection layer,
e.g. a different access control mechanism implemented by the web server
as shown in the example.  Do consider enabling phpMyAdmin only when it
is in use.