<p align="center">
<img src="/assets/images/logo.png" alt="Logo" style="width:200px;"/>
</p>

## Memasang paket melalui Packages(pkg) catatan hasil belajar FreeBSD support versi terbaru/versi belum EOL

#### Cek Version dan Update FreeBSD
Cek Versi mesin/PC FreeBSD
```sh
freebsd-version
```
Update Versi mesin/PC FreeBSD
```sh
freebsd-update fetch
freebsd-update install
```
## Menginstal melalui packages
Jika diperlukan upgrade versi mesin/PC dan paket FreeBSD
```sh
pkg update && pkg upgrade -y
```
install paket:
```sh
pkg install git
```

#### Sumber Belajar
1. [Installing Applications: Packages and Ports](https://docs.freebsd.org/en/books/handbook/ports/)
2. [Using Git to manage ports, source and documentation](https://forums.freebsd.org/threads/guide-using-git-to-manage-ports-source-and-documentation.79721/)
3. [FreeBSD Git repositories](https://cgit.freebsd.org/)
