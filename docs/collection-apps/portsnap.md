<p align="center">
<img src="/assets/images/logo.png" alt="Logo" style="width:200px;"/>
</p>

## Memasang paket melalui Portsnap/Ports catatan hasil belajar FreeBSD
Cek versi mesin/PC FreeBSD
```sh
freebsd-version
```
freebsd-update fetch
Update versi mesin/PC FreeBSD
```sh
freebsd-update -r 12.3-RELEASE upgrade
freebsd-update install
```
## Menginstal melalui portsnap/ports
Jika diperlukan upgrade versi mesin/PC dan paket FreeBSD
```sh
portsnap fetch update
```
install paket:
```sh
cd /usr/ports/devel/git && make install clean
```

#### Sumber Belajar
1. [Using the Ports Collection](https://docs.freebsd.org/en/books/handbook/ports/#ports-using)
2. [Using Git to manage ports, source and documentation](https://forums.freebsd.org/threads/guide-using-git-to-manage-ports-source-and-documentation.79721/)
3. [FreeBSD Git repositories](https://cgit.freebsd.org/)
