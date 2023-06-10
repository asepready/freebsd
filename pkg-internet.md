<p align="center">
<img src="./assets/images/logo.png" alt="Logo" style="width:200px;"/>
</p>

## Memasang paket melalui Packages(pkg) catatan hasil belajar FreeBSD support versi terbaru atau belum EOL

```sh
# Cek versi mesin/PC FreeBSD
freebsd-version

# Update versi mesin/PC FreeBSD
freebsd-update fetch
freebsd-update install
```
## Menginstal melalui packages melalui internet
Jika diperlukan upgrade versi mesin/PC dan paket FreeBSD
```sh
pkg update
pkg search git #cek ketersedia paket
pkg install git
```
### 2. Install paket dari file unduhan
Unduh file
```sh
pkg search nginx

pkg fetch -d -o ~/FreeBSD:13:i386/ nginx

pkg install nginx-lite-1.22.1,3.pkg
```
