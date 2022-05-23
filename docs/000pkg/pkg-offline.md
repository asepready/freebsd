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
1. [Downloading FreeBSD packages for offline installation | ](https://kgibran.wordpress.com/2016/01/12/downloading-freebsd-packages-for-offline-installation/)(https://kgibran.wordpress.com/2016/01/12/downloading-freebsd-packages-for-offline-installation/)
#### Struktur Folder
```sh
belajar-freebsd/
└── docs
    ├── 000pkg
    │   └── pkg-offline.md
    └── README.md
```

#### Mendownload Paket Aplikasi/Game pada mesin/PC FreeBSD Lokal/Offline
Langkah-Langkahnya:
1. Sebuah mesin/PC FreeBSD yang terhubung ke internet, arsitekturnya harus sesuai dengan target di mana Anda ingin menginstal paket-paket tersebut.
2. pkg diinstal yang menjalankan mesin/PC FreeBSD pada proses installnya melalui internet.
3. hak akses root pada mesin/PC
- perintah download paket melalui pkg
```sh
mkdir /root/off-pac
```
- lakukan update paket-paket terbaru
```sh
pkg update
```
- download paket aplikasi/game
```sh
pkg fetch -d -o  /root/off-pac   vlc
```
4. Sebuah media penyimpanan untuk mentransfer paket dari mesin/PC sumber ke mesin/PC yang lain.
