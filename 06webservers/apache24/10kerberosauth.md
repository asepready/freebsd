Apache httpd : Kerberos Authentication
 	
Limit accesses on specific web pages and use Windows Active Directory users for authentication with SSL connection.

Windows Active Directory is required in your local network, refer to here. This example is based on the environment like follows.

Domain Server	: Windows Server 2022
Domain Name	: belajarfreebsd.or.id
Hostname	: fd3s.belajarfreebsd.or.id
NetBIOS Name	: FD3S01
Realm	: BELAJARFREEDOS.OR.ID

[1]	Configure SSL/TLS Setting, refer to here.

[2]	For example, set Kerberos Authentication under the [/usr/local/www/apache24/data/auth-kerberos] directory.
```sh
root@www:~ # pkg install -y ap24-mod_auth_kerb2 krb5
root@www:~ # vi /etc/krb5.conf
# create new
[libdefaults]
    default_realm = BELAJARFREEDOS.OR.ID

[realms]
    BELAJARFREEDOS.OR.ID = {
      kdc = fd3s.belajarfreebsd.or.id
      admin_server = fd3s.belajarfreebsd.or.id
    }

root@www:~ # vi /usr/local/etc/apache24/Includes/auth-kerberos.conf
# create new
<Directory /usr/local/www/apache24/data/auth-kerberos>
    SSLRequireSSL
    AuthType Kerberos
    AuthName "Kerberos Authntication"
    KrbAuthRealms BELAJARFREEDOS.OR.ID
    KrbMethodNegotiate Off
    KrbSaveCredentials Off
    KrbVerifyKDC Off
    Require valid-user
</Directory>

root@www:~ # vi /usr/local/etc/apache24/httpd.conf
# line 184 : uncomment
LoadModule auth_kerb_module libexec/apache24/mod_auth_kerb.so
root@www:~ # service apache24 reload
# create a test page
root@www:~ # mkdir /usr/local/www/apache24/data/auth-kerberos
root@www:~ # vi /usr/local/www/apache24/data/auth-kerberos/index.html
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
Test Page for Kerberos Auth
</div>
</body>
</html>
```
[3]	Access to the test page with Web browser on any Client Computer, then authentication is required for settings. Authenticate with an existing Active Directory user.

[4]	That's OK if authentication passed and test page is shown normally.
