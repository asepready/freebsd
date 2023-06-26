## Konfigurasi Golang
Buka situs di https://go.dev/dl/ download dan ketersedian paket sesuai arsitektur sistem
```sh term
# download paket
pkg install go

#atau 
fetch https://go.dev/dl/go1.19.10.freebsd-amd64.tar.gz
tar xvf go1.19.10.freebsd-amd64.tar.gz

mv go /usr/local/etc/

# home/$user/.profile
export GOROOT=/usr/local/etc/go
export GOPATH=$HOME/sysadmin
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```