Mail Server : Add Mail User Accounts
 	
Add Mail User Accounts to use Mail Service.
This example is for the case you use OS user accounts.
Configure basic Postfix settings, and basic Dovecot settings first.

[1]	To use OS user accounts, that's only adding OS user like follows.
```sh
# install mail client program
root@mail:~# pkg install -y s-nail
# set environment variables to use Maildir
root@mail:~# echo 'export MAIL=$HOME/Maildir' >> /etc/profile.d/mail.sh
# add a user [sysadmin]
root@mail:~# pw useradd sysadmin -m
root@mail:~# passwd sysadmin
```
[2]	Login as a user added in [1] and try to send an email.
```sh
# send to myself [s-nail (username)@(hostname)]
sysadmin@mail:~ $ s-nail sysadmin@localhost

# input subject
Subject: Test Mail#1
# input messages
This is the first mail.

# to finish messages, push [Ctrl] + [D] key
-------
(Preliminary) Envelope contains:
To: sysadmin@localhost
Subject: Test Mail#1
Send this message [yes/no, empty: recompose]? yes

# see received emails
sysadmin@mail:~ $ s-nail
s-nail version v14.9.24.  Type `?' for help
/home/sysadmin/Maildir: 1 message 1 new
>N  1 User sysadmin       2024-04-17 14:41   14/437   Test Mail#1

# input a number you'd like to see an email
? 1
[-- Message  1 -- 14 lines, 437 bytes --]:
Date: Wed, 17 Apr 2024 14:41:40 +0900
To: sysadmin@localhost
Subject: Test Mail#1
Message-Id: <20240417054140.7782C10B55@mail.belajarfreebsd.or.id>
From: User sysadmin <sysadmin@belajarfreebsd.or.id>

This is the first mail.

# to quit, input [q]
? q
Held 1 message in /home/sysadmin/Maildir