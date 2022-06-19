<p align="center">
<img src="/assets/images/logo.png" alt="Logo" style="width:200px;"/>
</p>

## Catatan hasil belajar FreeBSD support versi =>11.*
#### Cek Version dan Update FreeBSD
Cek Versi mesin/PC FreeBSD
```sh
freebsd-version
```
Update Versi mesin/PC FreeBSD
```sh
freebsd-update fetch install
```
Jika diperlukan upgrade versi mesin/PC dan paket FreeBSD
```sh
pkg update && pkg upgrade -y
```
## Menyelesaikan masalah pada pkg-install melalui ports
```sh
pkg delete -f pkg && cd /usr/ports/ports-mgmt/pkg && make install clean
```
atau
```sh
 cd /usr/ports/ports-mgmt/pkg && make reinstall clean
```

#### Sunber Belajar
1. [Installing Applications: Packages and Ports](https://docs.freebsd.org/en/books/handbook/ports/)
1. [Downloading FreeBSD packages for offline installation | ](https://kgibran.wordpress.com/2016/01/12/downloading-freebsd-packages-for-offline-installation/)(https://kgibran.wordpress.com/2016/01/12/downloading-freebsd-packages-for-offline-installation/)
#### Struktur Folder
```sh
belajar-freebsd/
└── docs
    ├── 000pkg
    │   └── pkg-online.md
    └── README.md
```

#### Install Paket Aplikasi/Game pada mesin/PC FreeBSD
Langkah-Langkahnya:
1. Sebuah mesin/PC FreeBSD yang terhubung ke internet, arsitekturnya harus sesuai dengan target di mana Anda ingin menginstal paket-paket tersebut.
2. pkg diinstal yang menjalankan mesin/PC FreeBSD pada proses installnya melalui internet.
3. hak akses root pada mesin/PC
- lakukan update paket-paket terbaru
```sh
pkg update
```
- download paket aplikasi/game
```sh
pkg install vlc
```