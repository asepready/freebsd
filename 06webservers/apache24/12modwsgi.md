Apache httpd : Configure mod_wsgi2024/02/01

Install [mod_wsgi (WSGI : Web Server Gateway Interface)] to make Python scripts be fast.

[1]	Install [mod_wsgi].
```sh
root@www:~# pkg install -y ap24-py311-mod_wsgi
```
[2]	For example, For example, configure WSGI to be able to access to [/test_wsgi] from [/usr/local/www/apache24/data/test_wsgi.py].
```sh
root@www:~# vi /usr/local/etc/apache24/modules.d/270_mod_wsgi.conf
# uncomment
LoadModule wsgi_module libexec/apache24/mod_wsgi.so
root@www:~# vi /usr/local/etc/apache24/Includes/wsgi.conf
# create new
WSGIScriptAlias /test_wsgi /usr/local/www/apache24/data/test_wsgi.py
root@www:~# service apache24 reload
```
[3]	Create a test script which you set above.
```sh
root@www:~# vi /usr/local/www/apache24/data/test_wsgi.py
# create new
def application(environ, start_response):
    status = '200 OK'
    html = '<html>\n' \
           '<body>\n' \
           '<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">\n' \
           'WSGI Test Page\n' \
           '</div>\n' \
           '</body>\n' \
           '</html>\n'.encode("utf-8")
    response_header = [('Content-type','text/html')]
    start_response(status,response_header)
    return [html]
```
[4]	To use Django, Configure like follows. ( for Django settings, refer to here )
For example, Configure [test_app] under the [/home/sysadmin/testproject] which is owned by [sysadmin] user.
```sh
root@www:~# vi /usr/local/etc/apache24/Includes/django.conf
# create new
WSGIDaemonProcess testapp python-path=/home/sysadmin/testproject:/home/sysadmin/django/lib/python3.9/site-packages
WSGIProcessGroup testapp
WSGIScriptAlias /django /home/sysadmin/testproject/testproject/wsgi.py

<Directory /home/sysadmin/testproject>
    Require all granted
</Directory>

root@www:~# service apache24 reload
# if you use user directory like the example, it needs to change the directory permission
root@www:~# ls -ld /home/sysadmin
drwx------ 5 sysadmin sysadmin 14 Feb 1 11:47 /home/sysadmin
root@www:~# chmod 711 /home/sysadmin
```