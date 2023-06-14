## 1. Konfigurasi Repositori melalui Arsip Debian
Buka dan edit untuk /etc/apt/sources.list
```sh file
# /etc/apt/sources.list #laring
deb http://debian.faztrain.id/ wheezy main
```

Lakukan pengecekan pembaruan reposetori'
```sh
apt-get update
```
## 2 Pengujian Repository
```sh term
apt-cache search openssh-server
apt-get install openssh-server
```
konfigurasi
```sh
# config sudo  
gpasswd -a sysadmin sudo #term

#edit file /etc/ssh/sshd_config
Port 22
PermitRootLogin no
AllowUsers sysadmin
```
## 2.1 Konfigurasi SSH
Bagaimana masuk SSH tanpa password dengan Publik Key?</br>
A. Pada ``Client``,generate key pair (Public & Private Key) untuk masing client.</br>
B. Pada ``Server`` salin public key milik client ke server serta mengaktifkan mode autentikasi dengan public key pada SSH server

--------------

Langkah-langkahnya

1. Windows OS dengan Putty SSH Client
    ,generate key pair dengan puttygen, simpan private key di tempat aman dan simpan public key untuk disalin ke server.
2. Linux/BSD OS, generate key pair dengan perintah ssh-keygen -t rsa -b 4096 untuk generate key rsa dengan panjang 4096 bit (default 2048). Key pair tersimpan di ~/.ssh(id_rsa/private dan id_rsa.pub/public)
3. Konfigurasi pada server Debian 7
    - Buat folder .ssh pada home direktori user
    - Buat file authorized_keys di dalam folder .ssh
    - Paste public key milik client ke dalam file authorized_keys . 1 pub key pada 1 baris
    - Set directory & file permission. chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
    - Pastikan baris AuthorizedKeyFile pada /etc/ssh/sshd_config dalam aktif (tanpa #)

Untuk public key dari putty yang disimpan ke file harus kenversi agar di mengerti oleh openssh server => ssh-keygen -i -f [windows_public_key] yang dihasilkan berupa 1 baris 

--------------
## 2.2 Dasar-dasar SCP (Secure Copy)
1. Transfer(uploud) file dari client ke server<br>
    ```sh
    scp /path/file.mp3 user@ipaddress:~

    # Tambahkan parameter -p jika port tidak default
    scp -p 2222 /path/file.mp3 user@ipaddress:~
    ```
    Transfer(uploud) direktori dari client ke server<br>
    ```sh
    scp -r /path/dirname user@ipaddress:~

    # Tambahkan parameter -p jika port tidak default
    scp -r -p 2222 /path/dirname user@ipaddress:~ 
    ```
2. Transfer(download) file dari remote server ke client<br>
    ```sh
    scp user@ipaddress:~/file.mp3 /path/ 

    # Tambahkan parameter -p jika port tidak default
    scp -p 2222 user@ipaddress:~/file.mp3 /path/ 
    ```
    Transfer(download) direktori dari remote server ke client<br>
    ```sh
    scp -r user@ipaddress:~/dirname /path/

    # Tambahkan parameter -p jika port tidak default
    scp -r -p 2222 user@ipaddress:~/dirname/ /path  
    ```