# Hak Akses Direktori dan File pada Unix/Linux

buat direktori & beri akses di home
```sh
#ls -l
mkdir /home/sysadmin/web
mkdir /home/sysadmin/log
# ubah kepemilikan
chown -R sysadmin.sysadmin /home/sysadmin/web/
chown -R sysadmin.sysadmin /home/sysadmin/log/
# 755 format ( u=rwx, g=r-x, o=r-x )
chmod -R 755 /home/sysadmin/web
chmod -R 755 /home/sysadmin/log
```
### [ Catatan 1 ]
Hak akses yang akan diberikan, terdapat tiga kategori berdasarkan user.
1. user/owner ( u ) adalah user yang merupakan pemilik dari file/direktori.
2. group ( g ) adalah user lain yang se-grup dengan pemilik file/direktori.
3. other ( o ) adalah user yang bukan pemilik dan bukan pula yang se-grup
dengan pemilik.
### [ Catatan 2 ]
Hak akses yang diberikan terhadap file/direktori terdiri dari tiga jenis.
1. read ( r ) mengizinkan user membaca/melihat isi file/direktori.
2. write ( w ) mengizinkan user mengubah/memanipulasi isi file/direktori.
3. execute ( x ) mengizinkan user menjalankan/mengeksekusi isi file.
### [ Catatan 3 ]
Penggunaan kode hak akses pada perintah “chmod” mengacu ke Pengkodean pengaturan hak akses.
| Hak Akses | Kode |
| - | - |
| - - - | 0 |
| - - x | 1 |
| - w - | 2 |
| - w x | 3 |
| r - - | 4 |
| r - x | 5 |
| r w - | 6 |
| r w x | 7 |
