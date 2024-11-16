Nginx : Basic Authentication
 	
Set Basic Authentication to limit access on specific web pages.

[1]	Username and password are sent with plain text on Basic Authentication, so Use secure connection with SSL/TLS setting, refer to here.

[2]	Add setting on a site config you'd like to set. For example, set Basic Authentication under the [/auth-basic] directory.
```sh
root@www:~# pkg install -y py311-htpasswd
root@www:~# vi /usr/local/etc/nginx/nginx.conf
# add follows in the [server] section
    server {
        .....
        .....
        location /auth-basic {
              auth_basic            "Basic Auth";
              auth_basic_user_file  "/usr/local/etc/nginx/.htpasswd";
        }

root@www:~# mkdir /usr/local/www/nginx/auth-basic
root@www:~# service nginx reload
# add users for basic authentication
# [-c] is creating new file, add it only the first time
root@www:~# htpasswd.py -c -b /usr/local/etc/nginx/.htpasswd freebsd password
root@www:~# chmod 600 /usr/local/etc/nginx/.htpasswd
root@www:~# chown www /usr/local/etc/nginx/.htpasswd
# create a test page
root@www:~# vi /usr/local/www/nginx/auth-basic/index.html
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
Test Page for Basic Authentication
</div>
</body>
</html>
```
[3]	Access to the test page from any client computer with web browser. Then authentication is required as settings, answer with a user added in [2].

[4]	That's OK if authentication is successfully passed and test page is displayed normally.