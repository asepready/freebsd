Proxy Client : FreeBSD

Configure Proxy Clients to connect to the Proxy server.

[1]	Configure proxy settings like follows on FreeBSD Client.
```sh
root@client:~# vi /etc/profile.d/proxy.sh
# create new (set proxy settings to the environment variables for System wide)
MY_PROXY_URL="http://prox.belajarfreebsd.or.id:3128"

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
  HTTP_PROXY: "prox.belajarfreebsd.or.id:3128"
  HTTPS_PROXY: "prox.belajarfreebsd.or.id:3128"
  FTP_PROXY: "prox.belajarfreebsd.or.id:3128"
}

# for curl
root@client:~# vi ~/.curlrc
# create new
proxy=prox.belajarfreebsd.or.id:3128
# for wget
root@client:~# vi /usr/local/etc/wgetrc
# add to last line
http_proxy = prox.belajarfreebsd.or.id:3128
https_proxy = prox.belajarfreebsd.or.id:3128
ftp_proxy = prox.belajarfreebsd.or.id:3128
Proxy Client : Windows
 	
Configure proxy settings like follows on Windows Client.
```
[2]	This is an example to configure proxy setting for Google Chrome.
To open setting for proxy on Chrome like follows, proxy setting on Windows system wide opens.
It's possible to use proxy on Chrome to set on it.

[3]	If you'd like to set proxy only for Chrome, not for Windows system wide, add startup option [--proxy-server=(server's hostname or IP address):(proxy port)] to use proxy like follows.
