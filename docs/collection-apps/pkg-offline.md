<p align="center">
<img src="/assets/images/logo.png" alt="Logo" style="width:200px;"/>
</p>

## Catatan hasil belajar FreeBSD memasang paket/aplikasi secara offline / lokal
### 1. Melalui File DVD1.iso
Masukan file dvd1.iso FreeBSD dan mount kan
```sh
mount -t cd9660 /dev/cd0 /media
mkdir -p /usr/local/etc/pkg/repos
cp /media/packages//media/packages/repos/FreeBSD_install_cdrom.conf /usr/local/etc/pkg/repos/FreeBSD_install_cdrom.conf
```
edit /usr/local/etc/pkg/repos/FreeBSD_install_cdrom.conf
```sh
FreeBSD_install_cdrom: {
  url: "file:///media/packages/${ABI}",
  mirror_type: "none",
  enabled: yes
}

FreeBSD: {
  enabled: no
}
```
### 2. Remote Repository from FreeBSD.org
```sh
ftp ftp://ftp2.freebsd.org/pub/FreeBSD-Archive/ports/i386/packages-6-stable/All/

get nginx-0.8.53_1.tbz
```
Unduh file
```sh
fetch ftp://ftp2.freebsd.org/pub/FreeBSD-Archive/ports/i386/packages-6-stable/All/nginx-0.8.53_1.tbz
```
#### Sunber Belajar
1. [Installing Applications: Packages and Ports](https://docs.freebsd.org/en/books/handbook/ports/)
2. [Repo FreeBSD Packages](http://ftp2.freebsd.org/)(http://ftp2.freebsd.org/)
