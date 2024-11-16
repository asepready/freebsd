Apache httpd : Configure WebDAV
 	
Configure WebDAV Folder.

[1]	Configure SSL/TLS Setting, refer to here.

[2]	For example, Create a directory [/home/webdav] and it makes possible to connect to WebDAV folder only by HTTPS.
```sh
root@www:~ # vi /usr/local/etc/apache24/httpd.conf
# line 160 : uncomment
LoadModule dav_module libexec/apache24/mod_dav.so
# line 171,172 : uncomment
LoadModule dav_fs_module libexec/apache24/mod_dav_fs.so
LoadModule dav_lock_module libexec/apache24/mod_dav_lock.so
root@www:~ # mkdir /home/webdav
root@www:~ # chown www:www /home/webdav
root@www:~ # chmod 770 /home/webdav
root@www:~ # vi /usr/local/etc/apache24/Includes/webdav.conf
# create new
DavLockDB "/tmp/DavLock"
Alias /webdav /home/webdav
<Location /webdav>
    DAV On
    SSLRequireSSL
    Options +Indexes
    AuthType Basic
    AuthName WebDAV
    AuthUserFile /usr/local/etc/apache24/.htpasswd
    <RequireAny>
        Require method GET POST OPTIONS
        Require valid-user
    </RequireAny>
</Location>

BrowserMatch "Microsoft Data Access Internet Publishing Provider" redirect-carefully
BrowserMatch "MS FrontPage" redirect-carefully
BrowserMatch "^WebDrive" redirect-carefully
BrowserMatch "^WebDAVFS/1.[01234]" redirect-carefully
BrowserMatch "^gnome-vfs/1.0" redirect-carefully
BrowserMatch "^XML Spy" redirect-carefully
BrowserMatch "^Dreamweaver-WebDAV-SCM1" redirect-carefully
BrowserMatch " Konqueror/4" redirect-carefully

# add a user : create a new file with [-c]
root@www:~ # htpasswd -c /usr/local/etc/apache24/.htpasswd freebsd
New password:     # set password
Re-type new password:
Adding password for user freebsd
root@www:~ # service apache24 reload
```

[3]	Configure WebDAV client on client computer. This example is on Windows 11. Open [PC] and Click [Add a network location] icon on the upper-menu.

[4]	Click [Next] button.

[5]	Click [Next] button.

[6]	Input the URL of WebDav folder.

[7]	Authentication is required, input username and password you added in section [1] by [htpasswd].

[8]	Input WebDav Folder Name. Any name is OK, it's used on your Windows Computer.

[9]	Click [Finish] button.

[10] After you accessed to WebDav folder, you may check if the file can be read and written normally.
