<p align="center">
<img src="./../assets/images/logo.png" alt="Logo" style="width:200px;"/>
</p>

### Catatan hasil belajar FreeBSD support versi =>11.*
## Cara Mengubah Ukuran Disk pada FreeBSD
Sistem operasi FreeBSD menggunakan UFS (Unix File System) untuk sistem berkas pada partisi root; atau dikenal dengan nama `freebsd-ufs`.

Jika ukuran disk ditingkatkan, kami akan mengilustrasikan bagaimana cara memperluas sistem file ini.
### Persyaratan
-----------------------------------------------------------------------
1) Untuk mengikuti tutorial ini berikut menggunakan: FreeBSD 11 x64 atau terbaru

    Kami menggunakan paket berikut ini untuk memulai penerapan:
    | Komponen | Deskripsi |
    |--|--|
    | CPU | 1 vCore |
    | RAM | 512 MB |
    | Storage | 2 GB |

2) Sebelum meng-upgrade intance/VMs Anda, konfirmasikan alokasi disk & tabel partisi saat ini: 
    ```sh term
        data@FBSD12:~ $ df -h
        Filesystem    Size    Used   Avail Capacity  Mounted on
        /dev/da0p3    1.8G    1.4G    279M    84%    /
        devfs         1.0K    1.0K      0B   100%    /dev

        data@FBSD12:~ $ gpart show
        =>      40    4194224  da0  GPT  (2.0G)
                40      1024    1  freebsd-boot  (512K)
              1064    208896    2  freebsd-swap  (102M)
            209960   3984304    3  freebsd-ufs  (1.9G)
    ```

3) Tingkatkan paket intance/VMs Anda:

    Dalam hal ini, kami meningkatkan intance/VMs kami menjadi sebagai berikut:
    | Komponen | Deskripsi |
    |--|--|
    | CPU | 1 vCore |
    | RAM | 1024 MB |
    | Storage | 10 GB |
-----------------------------------------------------------------------
### 1. Konfirmasi Ruang Disk Baru
Meskipun alokasi disk tampak sama pada awalnya, gpart mengilustrasikan adanya perubahan:
```sh term
    root@lab-FBSD:~ # df -h
    Filesystem    Size    Used   Avail Capacity  Mounted on
    /dev/da0p3    1.8G    1.4G    279M    84%    /
    devfs         1.0K    1.0K      0B   100%    /dev

    root@lab-FBSD:~ # gpart show 
    =>      40  20971447  da0  GPT  (10G)[CORRUPT]
            40      1024    1  freebsd-boot  (512K)
          1064    208896    2  freebsd-swap  (102M)
        209960   3984304    3  freebsd-ufs  (1.9G)
```
### 2. Memulihkan Partisi yang Rusak
```sh term
    root@lab-FBSD:~ # gpart recover da0
    da0 recovered

    root@lab-FBSD:~ # gpart show 
    =>      40  20971447  da0  GPT  (10G)[CORRUPT]
            40      1024    1  freebsd-boot  (512K)
          1064    208896    2  freebsd-swap  (102M)
        209960   3984304    3  freebsd-ufs  (1.9G)
       4194264  16777223       - free -  (8.0G)
```
### 3. Resize the freebsd-ufs Partition
PERINGATAN!!!
`
Terdapat risiko kehilangan data saat memodifikasi tabel partisi pada sistem berkas yang telah disambungkan. Sebaiknya lakukan langkah-langkah berikut ini pada sistem file yang tidak disambungkan saat menjalankan dari CD-ROM atau perangkat USB.`

Karena ini adalah instans yang baru saja digunakan, tidak ada data sensitif yang perlu dicadangkan; namun, jika Anda mengupgrade instans yang saat ini sedang dalam produksi, sebaiknya lakukan pencadangan di luar lokasi sebelum melakukan perubahan apa pun pada tabel partisi.

Setelah Anda siap untuk melanjutkan, lakukan hal berikut:
```sh term
root@FBSD12:/home/data # gpart resize -i 3 da0
da0p3 resized

root@lab-FBSD:~ # gpart show
=>       0  20971520  da0  BSD  (10G)
         0   3983360    1  freebsd-ufs  (1.9G)
   3983360    208896    2  freebsd-swap  (8.1G)
```
### 4. Mengembangkan Sistem Berkas UFS
Untuk memperluas parisi freebsd-ufs atau /dev/da0p3, mulai layanan growfs:
```sh term
root@FBSD12:/home/data # service growfs onestart
```
Sebagai alternatif, Anda dapat menjalankan perintah berikut ini.
```sh term
root@FBSD12:/home/data # growfs  /dev/da0p3
```
### 5. Konfirmasikan Perubahan
```sh term
root@FBSD12:/home/data # df -h
Filesystem    Size    Used   Avail Capacity  Mounted on
/dev/da0p3    9.6G    1.4G    7.4G    16%    /
devfs         1.0K    1.0K      0B   100%    /dev

root@FBSD12:/home/data # gpart show
=>      40  20971447  da0  GPT  (10G)
        40      1024    1  freebsd-boot  (512K)
      1064    208896    2  freebsd-swap  (102M)
    209960  20761527    3  freebsd-ufs  (9.9G)
```