# Struktur Folder dan File
```
├── bind.keys
├── dynamic
├── named.conf
├── named.conf.sample
├── named.root
└── primary
    ├── 0.db
    ├── 127.db
    └── local.db
```

# BIND : Configure for Internal Network
Instal BIND untuk mengonfigurasi DNS (Domain Name System) Server untuk menyediakan layanan Resolusi Nama atau Alamat untuk Klien.
[1]	Install Paket BIND.
```sh
root@dlp:~ # pkg install -y bind918 bind-tools
```
[2]	Contoh Konfigurasi jaringan Internal & Eksternal DNS Server.
        
A. Pada contoh ini, Konfigurasikan BIND untuk [Jaringan Internal](./named-int.conf). Contoh berikut ini adalah untuk kasus Jaringan lokal adalah [9.9.9.0/24], Nama domain adalah [asepready.id], Ganti ke lingkungan Anda sendiri.
        
B. Pada contoh ini, Konfigurasikan BIND untuk [Jaringan Eksternal](./named-ext.conf). Contoh berikut ini adalah untuk kasus Jaringan eksternal adalah [192.168.122.0/24], Nama domain adalah [asepready.id], Ganti ke lingkungan Anda sendiri. (Sebenarnya, [192.168.122.0/24] adalah untuk alamat IP pribadi, ganti ke alamat IP global Anda. )

[3]	[Konfigurasikan File Zona /usr/local/etc/namedb/primary/db.asepready](./primary/db.asepready) untuk setiap Zona yang ditetapkan di [named.conf].

[4]     Mulai layanan bernama dan Ubah pengaturan DNS untuk merujuk ke server Anda jika perlu.
```sh
root@dlp:~ # service named enable
root@dlp:~ # service named start
root@dlp:~ # cat << EOF >> /etc/resolv.conf
search asepready.id
nameserver 9.9.9.3
EOF
root@dlp:~ # dig ns.asepready.id.
root@dlp:~ # dig -x 9.9.9.3
```
