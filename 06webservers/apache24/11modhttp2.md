Apache httpd : Configure mod_http2
 	
Configure [mod_http2] to use HTTP/2.

[1]	Configure SSL/TLS settings, refer to here. (many Web browsers support HTTP/2 only on HTTPS connection)

[2]	Install mod_http2.
```sh
root@www:~ # pkg install -y ap24-mod_http2
```
[3]	Configure [mod_http2].
```sh
root@www:~ # vi /usr/local/etc/apache24/httpd.conf
# line 66, 67 : comment out prefork and uncomment event
LoadModule mpm_event_module libexec/apache24/mod_mpm_event.so
#LoadModule mpm_prefork_module libexec/apache24/mod_mpm_prefork.so
root@www:~ # vi /usr/local/etc/apache24/modules.d/200_mod_h2.conf
# line 3 : uncomment and change
LoadModule http2_module libexec/apache24/mod_h2.so

<IfModule http2_module>
Protocols h2 http/1.1
ProtocolsHonorOrder On
</IfModule>

root@www:~ # service apache24 restart
# verify accesses
# OK if [HTTP/2] is shown
root@www:~ # curl -I https://www.srv.world/
HTTP/2 200
last-modified: Tue, 30 Jan 2024 00:21:58 GMT
etag: "82-6101ec01fa41e"
accept-ranges: bytes
content-length: 130
content-type: text/html
date: Wed, 31 Jan 2024 05:01:59 GMT
server: Apache/2.4.58 (FreeBSD) OpenSSL/3.0.12 mod_auth_kerb/5.4
```
It's possible to see HTTP/2 in response header from Web browser access. The example below is on Edge. If HTTP/2 is enabled, [Protocol] in response header turns to [h2] like follows.