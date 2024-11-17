Mail Server : Postfix + Clamav + Amavisd
 	
Configure Virus-Scanning for EMails with Postfix + Clamav.

[1]	Install Clamav, refer to here.

[2]	Install Amavisd and Clamav Server.
```sh
root@mail:~# pkg install -y amavisd-new p5-Digest-SHA1 p5-IO-Stringy
root@mail:~# vi /usr/local/etc/clamd.conf
# line 81 : uncomment
TemporaryDirectory /var/tmp
root@mail:~# service clamav-clamd enable
clamav_clamd enabled in /etc/rc.conf
root@mail:~# service clamav-clamd start
Starting clamav_clamd.
```
[3]	Configure Amavisd.
```sh
root@mail:~# vi /usr/local/etc/amavisd.conf
# line 13, 14 : uncomment and add the line if not use spam check
@bypass_spam_checks_maps  = (1);  # controls running of anti-spam code
$undecipherable_subject_tag = undef;

# line 23 : change to your domain name
$mydomain = 'srv.world';

# line 156 : uncomment and change to your hostname
$myhostname = 'mail.srv.world';

# line 158, 159 : uncomment
$notify_method  = 'smtp:[127.0.0.1]:10025';
$forward_method = 'smtp:[127.0.0.1]:10025';  # set to undef with milter!

# line 387 - 390 : uncomment
['ClamAV-clamd',
  \&ask_daemon, ["CONTSCAN {}\n", "/var/run/clamav/clamd.sock"],
  qr/\bOK$/m, qr/\bFOUND$/m,
  qr/^.*?: (?!Infected Archive)(.*) FOUND$/m ],

# line 756 - 759 : comment out
#  ### http://www.clamav.net/   - backs up clamd or Mail::ClamAV
#  ['ClamAV-clamscan', 'clamscan',
#    "--stdout --no-summary -r --tempdir=$TEMPBASE {}",
#    [0], qr/:.*\sFOUND$/m, qr/^.*?: (?!Infected Archive)(.*) FOUND$/m ],

root@mail:~# service amavisd enable
amavisd enabled in /etc/rc.conf
root@mail:~# service amavisd start
Starting amavisd.
```
[4]	Configure Postfix.
```sh
root@mail:~# vi /usr/local/etc/postfix/main.cf
# add follows to last line
content_filter=smtp-amavis:[127.0.0.1]:10024
root@mail:~# vi /usr/local/etc/postfix/master.cf
# add follows to last line
smtp-amavis unix -    -    n    -    2 smtp
    -o smtp_data_done_timeout=1200
    -o smtp_send_xforward_command=yes
    -o smtp_dns_support_level=disabled
127.0.0.1:10025 inet n    -    n    -    - smtpd
    -o content_filter=
    -o local_recipient_maps=
    -o relay_recipient_maps=
    -o smtpd_restriction_classes=
    -o smtpd_client_restrictions=
    -o smtpd_helo_restrictions=
    -o smtpd_sender_restrictions=
    -o smtpd_recipient_restrictions=permit_mynetworks,reject
    -o mynetworks=127.0.0.0/8
    -o strict_rfc821_envelopes=yes
    -o smtpd_error_sleep_time=0
    -o smtpd_soft_error_limit=1001
    -o smtpd_hard_error_limit=1000

root@mail:~# service postfix reload
```
[5]	That' OK. [X-Virus-Scanned: ***] lines are added in the header section of emails after this configuration and emails with known Virus will not sent to Clients.
