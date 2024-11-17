Squid : Basic Authentication
 	
Set Basic Authentication to limit access to Squid.

[1]	Install a package which includes htpasswd.
```sh
root@prox:~# pkg install -y apache24
```
[2]	Configure Squid to set Basic Authentication.
```sh
root@prox:~# vi /usr/local/etc/squid/squid.conf
.....
.....
acl Safe_ports port 777         # multiling http
# line 28 : add follows for Basic auth
auth_param basic program /usr/local/libexec/squid/basic_ncsa_auth /usr/local/etc/squid/.htpasswd
auth_param basic children 5
auth_param basic realm Squid Basic Authentication
auth_param basic credentialsttl 4 hours
acl password proxy_auth REQUIRED
http_access allow password

root@prox:~# service squid restart
# add a user : create new file with [-c] option
root@prox:~# htpasswd -c /usr/local/etc/squid/.htpasswd freebsd
New password:   # set password
Re-type new password:
Adding password for user freebsd
Proxy Client : FreeBSD
```
[3]	Configure FreeBSD Proxy Client for Basic Authentication.
```sh
root@client:~# vi /etc/profile.d/proxy.sh
# create new
# username:password@proxyserver:port
MY_PROXY_URL="http://freebsd:password@prox.belajarfreebsd.or.id:3128"

HTTP_PROXY=$MY_PROXY_URL
HTTPS_PROXY=$MY_PROXY_URL
FTP_PROXY=$MY_PROXY_URL
http_proxy=$MY_PROXY_URL
https_proxy=$MY_PROXY_URL
ftp_proxy=$MY_PROXY_URL

export HTTP_PROXY HTTPS_PROXY FTP_PROXY http_proxy https_proxy ftp_proxy

root@client:~# . /etc/profile.d/proxy.sh
# otherwise, it's possible to set proxy settings for each application, not System wide
# for pkg
root@client:~# vi /usr/local/etc/pkg.conf
# add to last line
pkg_env : {
  HTTP_PROXY: "freebsd:password@prox.belajarfreebsd.or.id:3128"
  HTTPS_PROXY: "freebsd:password@prox.belajarfreebsd.or.id:3128"
  FTP_PROXY: "freebsd:password@prox.belajarfreebsd.or.id:3128"
}

# for curl
root@client:~# vi ~/.curlrc
# create new
proxy=prox.belajarfreebsd.or.id:3128
proxy-user=freebsd:password
# for wget
root@client:~# vi /usr/local/etc/wgetrc
# add to last line
http_proxy = prox.belajarfreebsd.or.id:3128
https_proxy = prox.belajarfreebsd.or.id:3128
ftp_proxy = prox.belajarfreebsd.or.id:3128
proxy_user = freebsd
proxy_passwd = password
Proxy Client : Windows
```
[4]	For Windows Clients, none of specific settings, when access to a web, proxy server requires authentication like follows, then input username and password.
