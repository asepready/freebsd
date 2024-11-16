Apache httpd : Basic Authentication + PAM

Limit accesses on specific web pages and use OS users for authentication with SSL connection.

[1]	Configure SSL/TLS Setting, refer to here.

[2]	For example, set Basic Authentication under the [/usr/local/www/apache24/data/auth-pam] directory.
```sh
root@www:~ # pkg install -y ap24-mod_authnz_external24 pwauth
root@www:~ # vi /usr/local/etc/apache24/Includes/auth-pam.conf
# create new
LoadModule authnz_external_module libexec/apache24/mod_authnz_external.so

AddExternalAuth pwauth /usr/local/bin/pwauth
SetExternalAuthMethod pwauth pipe
<Directory /usr/local/www/apache24/data/auth-pam>
    SSLRequireSSL
    AuthType Basic
    AuthName "PAM Authentication"
    AuthBasicProvider external
    AuthExternal pwauth
    require valid-user
</Directory>

root@www:~ # mkdir /usr/local/www/apache24/data/auth-pam
root@www:~ # service apache24 reload
# create a test page
root@www:~ # vi /usr/local/www/apache24/data/auth-pam/index.html
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
Test Page for PAM Auth
</div>
</body>
</html>
```
[3]	Access to the test page with a Web browser on any Client Computer, then authentication is required for settings. Authenticate with an existing OS user.

[4]	That's OK if authentication passed and test page is shown normally.
