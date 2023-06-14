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