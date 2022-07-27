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
- cari Paket MariaDB
```sh
pkg sea mariadb103-server
```
- download atau install lewat internet paket aplikasi/game
Menginstall paket dari internet tanpa tersimpan di mesin/PC FreeBSD lokal.
```sh
pkg ins mariadb103-server
```
Mengunduh paket dari internet file unduh tersimpan di mesin/PC FreeBSD lokal
```sh
pkg fetch -d -o /root/off-pac mariadb103-server
```
4. Sebuah media penyimpanan untuk mentransfer paket dari mesin/PC sumber ke mesin/PC yang lain.
