## Mengizinkan Akses Root pada SSH
Ubah baris pada file /etc/ssh/sshd_config
```sh file
    #PermitRootLogin no
    ---
    #PasswordAuthentication no
    #PermitEmptyPasswords no
    ---
```
menjadi
```sh file
    PermitRootLogin yes
    ---
    PasswordAuthentication yes
    PermitEmptyPasswords yes
    ---
```