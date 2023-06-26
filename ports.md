<p align="center">
<img src="./assets/images/logo.png" alt="Logo" style="width:200px;"/>
</p>

## Memasang paket melalui Ports/Portsnap catatan hasil belajar FreeBSD support versi terbaru atau belum EOL

1. Setup the Ports Collection:
```sh
cd /usr/ports/

portsnap fetch extract
portsnap fetch update
```
2. Navigating the Ports Collection
https://www.freebsd.org/ports/
```sh
cd /usr/ports/ssh
```
3. Installing the Port
```sh
make install clean
```