Pesan dari db5-5.3.28_9:

--
===> PEMBERITAHUAN:

Port db5 saat ini tidak memiliki pemelihara. Akibatnya, port ini kemungkinan besar memiliki masalah yang belum terselesaikan, tidak mutakhir, atau bahkan dihapus di masa depan masa depan. Untuk menjadi sukarelawan untuk memelihara port ini, silakan buat isu di:

https://bugs.freebsd.org/bugzilla

Informasi lebih lanjut tentang pemeliharaan pelabuhan tersedia di:

https://docs.freebsd.org/en/articles/contributing/#ports-contributing
--
===> PEMBERITAHUAN:

Port ini sudah tidak digunakan lagi; Anda mungkin ingin mempertimbangkan untuk menginstalnya:

EOLd, potensi masalah keamanan, mungkin gunakan db18 sebagai gantinya.

Port ini dijadwalkan akan dihapus pada atau setelah 2022-06-30.
=====
Pesan dari ca_root_nss-3.89:

--
FreeBSD tidak, dan tidak dapat menjamin bahwa otoritas sertifikasi
yang sertifikatnya disertakan pada paket ini dengan cara apapun telah
telah diaudit untuk kepercayaan atau kepatuhan terhadap RFC 3647.

Penilaian dan verifikasi kepercayaan adalah tanggung jawab penuh dari
administrator sistem.


Paket ini menginstal symlinks untuk mendukung penemuan sertifikat root oleh
default untuk perangkat lunak yang menggunakan OpenSSL.

Ini memungkinkan Verifikasi Sertifikat SSL oleh perangkat lunak klien tanpa manual
manual.

Jika Anda lebih suka melakukannya secara manual, ganti symlink berikut ini dengan
baik file kosong atau bundel sertifikat lokal situs Anda.

  * /etc/ssl/cert.pem
  * /usr/local/etc/ssl/cert.pem
  * /usr/local/openssl/cert.pem
=====
Pesan dari apr-1.7.0.1.6.1_2:

--
Proyek Apache Portable Runtime telah menghapus dukungan untuk FreeTDS dengan
versi 1.6. Pengguna yang membutuhkan konektivitas MS-SQL harus melakukan migrasi
konfigurasi untuk menggunakan driver ODBC yang ditambahkan dan fitur ODBC FreeTDS.
=====
Pesan dari apache24-2.4.56:

--
Untuk menjalankan server www apache dari startup, tambahkan apache24_enable = "yes"
di /etc/rc.conf Anda. Opsi tambahan dapat ditemukan pada skrip startup.

Nama host Anda harus dapat diselesaikan dengan menggunakan setidaknya 1 mekanisme di
/etc/nsswitch.conf biasanya DNS atau /etc/hosts atau apache mungkin
mungkin mengalami masalah saat memulai tergantung pada modul yang Anda gunakan.


- build default apache24 berubah dari MPM statis ke MPM modular
- lebih banyak modul sekarang diaktifkan per default di port
- ikon dan halaman kesalahan dipindahkan dari WWWDIR ke DATADIR

   Jika membangun dengan MPM modular dan tidak ada MPM yang diaktifkan di
   httpd.conf, maka mpm_prefork akan diaktifkan sebagai default
   MPM di etc/apache24/modules.d untuk menjaga kompatibilitas dengan
   modul php/perl/python yang sudah ada!

Silakan bandingkan httpd.conf yang ada dengan httpd.conf.sample
dan gabungkan modul/instruksi yang hilang ke dalam httpd.conf!