<p align="center">
<img src="/assets/images/logo.png" alt="Logo" style="width:200px;"/>
</p>

# Memasang paket melalui Packages(pkg) atau Ports
## Catatan hasil belajar FreeBSD support versi =>11.*

#### Struktur Folder
```sh
belajar-freebsd/
└── docs
    └── 000pkg
        └── README.md
```

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
## Menginstal melalui ports
```sh
pkg delete -f pkg && cd /usr/ports/ports-mgmt/pkg && make install clean
```
atau
```sh
 cd /usr/ports/ports-mgmt/pkg && make reinstall clean
```

#### Sumber Belajar
1. [Installing Applications: Packages and Ports](https://docs.freebsd.org/en/books/handbook/ports/)
