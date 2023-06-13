# Layanan Email
```sh
pkg install postfix courier-imap

#lokasi MailBox atau penyimpan semua pesan email dari setiap user
maildirmake /etc/skel/Maildir
nano /etc/postfix/main.cf
```
Konfig 
```sh file
# edit baris dan 10.3.1.0/24 (network server)
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128

#menjadi:
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 10.3.1.0/24

#tambahkan di bawah file main.cf
home_mailbox = Maildir/
```

service postfix restart

pengujian:
```sh
root@abcnet-1:~# adduser fatimah
Adding user `fatimah' ...
Adding new group `fatimah' (1001) ...
Adding new user `fatimah' (1001) with group `fatimah' ...
Creating home directory `/home/fatimah' ...
Copying files from `/etc/skel' ...
Enter new UNIX password: <ketik password, misal: 123456>
Retype new UNIX password: <ketik password, misal: 123456>
passwd: password updated successfully
Changing the user information for fatimah
Enter the new value, or press ENTER for the default
Full Name []: Fatiman Az-Zahra
Room Number []:
Work Phone []:
Home Phone []:
Other []:
Is the information correct? [Y/n] <tekan y>
```

MUA
```sh file
pkg install roundcube-php80
nano /var/lib/roundcube/config/main.inc.php

$rcmail_config['default_host'] = 'abcnet-1.id';
$rcmail_config['smtp_server'] = 'abcnet-1.id';
```