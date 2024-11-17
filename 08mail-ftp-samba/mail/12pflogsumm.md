Mail Server : Mail Log Report : pflogsumm
 	
Install pflogsumm which is the Postfix Log reporting tool.

[1]	Install postfix-perl-scripts package.
```sh
root@mail:~# pkg install -y pflogsumm
# generate mail log summary for yesterday
root@mail:~# perl /usr/local/bin/pflogsumm -d yesterday /var/log/maillog
Postfix log summaries for Apr 17

Grand Totals
------------
messages

     23   received
     17   delivered
      0   forwarded
      1   deferred  (3  deferrals)
     12   bounced
      2   rejected (10%)
      0   reject warnings
      0   held
      0   discarded (0%)

  24411   bytes received
  11770   bytes delivered
      4   senders
      2   sending hosts/domains
      4   recipients
      3   recipient hosts/domains


Per-Hour Traffic Summary
------------------------
    time          received  delivered   deferred    bounced     rejected
    --------------------------------------------------------------------
    0000-0100           0          0          0          0          0
    0100-0200           0          0          0          0          0
    0200-0300           0          0          0          0          0
    0300-0400           0          0          0          0          0
    0400-0500           0          0          0          0          0
    0500-0600           0          0          0          0          0
    0600-0700           0          0          0          0          0
    0700-0800           0          0          0          0          0
    0800-0900           0          0          0          0          0
    0900-1000           0          0          0          0          0
    1000-1100           0          0          0          0          0
    1100-1200           0          0          0          0          0
    1200-1300           0          0          0          0          0
    1300-1400           0          0          0          0          0
    1400-1500           4          4          0          0          0
    1500-1600           2          2          0          0          2
    1600-1700          14          9          3         10          0
    1700-1800           3          2          0          2          0
    1800-1900           0          0          0          0          0
    1900-2000           0          0          0          0          0
    2000-2100           0          0          0          0          0
    2100-2200           0          0          0          0          0
    2200-2300           0          0          0          0          0
    2300-2400           0          0          0          0          0

Host/Domain Summary: Message Delivery
--------------------------------------
 sent cnt  bytes   defers   avg dly max dly host/domain
 -------- -------  -------  ------- ------- -----------
     11     8467        3     3.6 m   39.1 m  belajarfreebsd.or.id
      3     1686        0     0.0 s    0.0 s  mail.belajarfreebsd.or.id
      3     1617        0     0.1 s    0.2 s  localhost

Host/Domain Summary: Messages Received
---------------------------------------
 msg cnt   bytes   host/domain
 -------- -------  -----------
     14    10153   mail.belajarfreebsd.or.id
      9    14258   belajarfreebsd.or.id

Senders by message count
------------------------
     14   freebsd@mail.belajarfreebsd.or.id
      6   virusalert@belajarfreebsd.or.id
      2   freebsd@belajarfreebsd.or.id
      1   openbsd@belajarfreebsd.or.id

Recipients by message count
---------------------------
     11   openbsd@belajarfreebsd.or.id
      3   freebsd@mail.belajarfreebsd.or.id
      2   openbsd@localhost
      1   freebsd@localhost

Senders by message size
-----------------------
  12641   virusalert@belajarfreebsd.or.id
  10153   freebsd@mail.belajarfreebsd.or.id
   1292   freebsd@belajarfreebsd.or.id
    325   openbsd@belajarfreebsd.or.id

Recipients by message size
--------------------------
   8467   openbsd@belajarfreebsd.or.id
   1686   freebsd@mail.belajarfreebsd.or.id
   1269   openbsd@localhost
    348   freebsd@localhost

message deferral detail: none

message bounce detail (by relay)
--------------------------------
  local (total: 12)
        12   unknown user: "virusalert"

message reject detail: none

message reject warning detail: none

message hold detail: none

message discard detail: none

smtp delivery failures: none

Warnings: none

Fatal Errors: none

Panics: none

Master daemon messages
----------------------
      7   daemon started -- version 3.9, configuration /usr/local/etc/postfix
      6   reload -- version 3.9, configuration /usr/local/etc/postfix
      5   terminating on signal 15