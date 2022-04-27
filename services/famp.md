<p align="center">
<img src="/assets/images/logo.png" alt="Logo" style="width:200px;"/>
<h1>FAMP</h1>
<h1>FreeBSD.Apache.MariaDB.PHP</h1>
</p>

## Catatan hasil belajar FreeBSD support versi =>11.* sebagai Server

#### Cari bahan pembelajaran di direktori
```sh
# 1 Repo
belajar-freebsd/docs/000pkg/
├── pkg-offline.md
└── pkg-online.md
# 2 Install dan konfigurasi paket
## Install
belajar-freebsd/docs/fbsd11/services/01http/
├── apache24.md
└── README.md
belajar-freebsd/docs/fbsd11/services/13program-language/
├── php.md
└── README.md
## konfigurasi
belajar-freebsd/services/fbsd11/01http/apache24/
├── etc
│   └── rc.conf
├── README.md
└── usr
    └── local
        └── etc
            └── apache24
                └── httpd.conf
# 3 Konfigurasi hostname dan hosts
belajar-freebsd/configs/hosts/
├── etc
│   ├── hosts
│   └── rc.conf
└── README.md
# 4 Konfigurasi php74 dan apache24
belajar-freebsd/services/fbsd11/13program-language/php74/apache24/
└── usr
    └── local
        ├── etc
        │   ├── apache24
        │   │   └── httpd.conf
        │   └── php.ini
        └── www
            └── apache24
                └── data
                    └── phpinfo.php

```
