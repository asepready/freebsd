OpenSSH : Use SSH-Agent2023/12/19
 	
Use SSH-Agent to automate inputting passphrase on key-pair authentication.

Using SSH-Agent is valid for users who set SSH Key Pair with Passphrase.

[1]	It's necessarry to set key-pair with Passphrase first.

[2]	This is how to use SSH-Agent.
```sh
# start SSH-Agent
sysadmin@node01:~ $ eval $(ssh-agent)
Agent pid 1129
# add Identity
sysadmin@node01:~ $ ssh-add
Enter passphrase for /home/sysadmin/.ssh/id_rsa:
Identity added: /home/sysadmin/.ssh/id_rsa (sysadmin@belajarfreebsd)
# confirm
sysadmin@node01:~ $ ssh-add -l
3072 SHA256:uNTwILz1kwqxTKplnlSWcxqEIB0mZQlyERz2wRML1yE sysadmin@belajarfreebsd (RSA)
# try to connect with SSH without passphrase
sysadmin@node01:~ $ ssh belajarfreebsd hostname
belajarfreebsd
# exit from SSH-Agent
sysadmin@node01:~ $ eval $(ssh-agent -k)
Agent pid 1129 killed