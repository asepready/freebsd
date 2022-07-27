#### Mendownload Paket Aplikasi/Game pada mesin/PC FreeBSD Lokal/Offline
Langkah-Langkahnya:
1. Sebuah mesin/PC FreeBSD yang terhubung ke internet, arsitekturnya harus sesuai dengan target di mana Anda ingin menginstal paket-paket tersebut.
2. pkg diinstal yang menjalankan mesin/PC FreeBSD pada proses installnya melalui internet.
3. hak akses root pada mesin/PC
  - buat direktori off-pac di dalam /root/:
  ```sh
  mkdir /root/off-pac
  ```
  - lakukan update paket-paket terbaru
  ```sh
  pkg update
  ```
  - cari Paket PHP + Apache/Nginx

    Paket php74 + phpMyAdmin-php74 + apache24    
  ```sh
  pkg sea php74 php74-mysqli php74-extensions mod_php74 #Modul Apache24(mod_php74)
  ```
    Paket php74 + nginx    
  ```sh
  pkg sea php74 php74-mysqli php74-extensions nginx-1.20
  ```
  - download atau install lewat internet paket aplikasi/game
  Menginstall paket dari internet tanpa tersimpan di mesin/PC FreeBSD lokal.
  ```sh
  pkg ins php74
  pkg ins mod_php74 #Modul Apache24(mod_php74)
  ```
  Mengunduh paket dari internet file unduh tersimpan di mesin/PC FreeBSD lokal
  ```sh
  pkg fetch -d -o /root/off-pac php74
  pkg fetch -d -o /root/off-pac mod_php74 #Modul Apache24(mod_php74)
  ```
4. Sebuah media penyimpanan untuk mentransfer paket dari mesin/PC sumber ke mesin/PC yang lain.
