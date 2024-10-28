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
zfs create -o mountpoint=/pkg zroot/pkg #ZFS
pkg search nginx
pkg fetch -d -o /pkg/FreeBSD:14:i386/ nginx-lite
pkg install nginx-lite-1.22.1,3.pkg
```

### 3. Bersihkan 
```sh
pkg clean -a
pkg clean -y
pkg audit -F
```
