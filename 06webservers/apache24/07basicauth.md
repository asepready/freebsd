Apache httpd : Basic Authentication
 	
Set Basic Authentication to limit access on specific web pages.

[1]	Username and password are sent with plain text on Basic Authentication, so Use secure connection with SSL/TLS setting, refer to here.

[2]	Configure httpd. For example, set Basic Authentication to the directory [/usr/local/www/apache24/data/auth-basic].
```sh
root@www:~ # vi /usr/local/etc/apache24/Includes/auth_basic.conf
# create new
<Directory /usr/local/www/apache24/data/auth-basic>
    SSLRequireSSL
    AuthType Basic
    AuthName "Basic Authentication"
    AuthUserFile /usr/local/etc/apache24/.htpasswd
    Require valid-user
</Directory> 

# add a user : create a new file with [-c]
root@www:~ # htpasswd -c /usr/local/etc/apache24/.htpasswd freebsd
New password:     # set password
Re-type new password:
Adding password for user freebsd
root@www:~ # mkdir /usr/local/www/apache24/data/auth-basic
root@www:~ # service apache24 reload
# create a test page
root@www:~ # vi /usr/local/www/apache24/data/auth-basic/index.html
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
Test Page for Basic Authentication
</div>
</body>
</html>
```
[3]	Access to the test page from any client computer with web browser. Then authentication is required as settings, answer with a user added in [1].

[4]	That's OK if authentication is successfully passed and test page is displayed normally.
