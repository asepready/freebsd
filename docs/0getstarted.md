# Memulai FreeBSD
<p align="center">
<img src="./../assets/images/logo.png" alt="Logo" style="width:200px;"/>
</p>

## 1. Install FreeBSD & Paket
## 2. Konfigurasi IP Dinamis/Statik Pada NIC
buka dan edit untuk hostname di /etc/rc.conf
```sh term
#/etc/rc.conf
ifconfig_em0="DHCP" #IPv4 DHCP
ifconfig_em0="inet 10.10.10.3 netmask 255.255.255.0" #IPv4 STATIC
defaultrouter="10.10.10.2" #IPv4 Gateway

ifconfig_em0_ipv6="inet6 accept_rtadv" #IPv6 DHCP 
```
restart service
```sh
service netif restart && service routing restart
# atau berdasar NIC
ifconfig network-interface down
ifconfig network-interface up
```
## 3. Merubah alias & nama Host 
buka dan edit untuk hostname di /etc/rc.conf
```sh
#/etc/rc.conf
hostname="lab-fbsd"
```
alias hosts
```sh
  #Set Hosts
    ::1                     localhost lab-fbsd.edu
    ::1                     lab-fbsd lab-fbsd.edu
    127.0.0.1               localhost lab-fbsd.edu
    127.0.0.1               lab-fbsd lab-fbsd.edu
  # I added here
    192.168.122.2           lab-fbsd.edu lab-fbsd
```
## 3. Konfigurasi SSH
Bagaimana masuk SSH tanpa password dengan Publik Key?</br>
A. Pada ``Client``,generate key pair (Public & Private Key) untuk masing client.</br>
B. Pada ``Server`` salin public key milik client ke server serta mengaktifkan mode autentikasi dengan public key pada SSH server

--------------

Langkah-langkahnya

1. Windows OS dengan Putty SSH Client
    ,generate key pair dengan puttygen, simpan private key di tempat aman dan simpan public key untuk disalin ke server.
2. Linux/BSD OS, generate key pair dengan perintah ssh-keygen -t rsa -b 4096 untuk generate key rsa dengan panjang 4096 bit (default 2048). Key pair tersimpan di ~/.ssh(id_rsa/private dan id_rsa.pub/public)
3. Konfigurasi pada server *BSD
    - Buat folder .ssh pada home direktori user
    - Buat file authorized_keys di dalam folder .ssh
    - Paste public key milik client ke dalam file authorized_keys . 1 pub key pada 1 baris
    - Set directory & file permission. chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
    - Pastikan baris AuthorizedKeyFile pada /etc/ssh/sshd_config dalam aktif (tanpa #)

Untuk public key dari putty yang disimpan ke file harus kenversi agar di mengerti oleh openssh server => ssh-keygen -i -f [windows_public_key] yang dihasilkan berupa 1 baris 

--------------
Dasar-dasar SCP (Secure Copy)
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