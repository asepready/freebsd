Mail Server : Set SPF Checking
 	
Configure Postfix to check SPF (Sender Policy Framework) when receiving mail.

For setting SPF as a sender, refer to Setting SPF Records on DNS Server.

[1]	Configure Postfix.
```sh
root@mail:~# pkg install -y py311-spf-engine
root@mail:~# vi /usr/local/etc/python-policyd-spf/policyd-spf.conf
# debug level (-1,0,1,2,3,4)
# 4 is max, -1 means nothing is logged
debugLevel = 1

# to run in test-only mode, change to [TestOnly = 0]
# in test-only mode, mail will not be rejected due to SPF checks
TestOnly = 1

# HELO/EHLO CHECKING
# - [Fail] : reject only on HELO Fail
# - [SPF_Not_Pass] : reject if result not Pass, None, Temperror
# - [Softfail] : reject on HELO Softfail or Fail
# - [Null] : only reject HELO Fail for Null sender
# - [False] : never reject on HELO, append header only
# - [No_Check] : never check HELO
HELO_reject = Fail

# Mail From CHECKING
# - [Fail] : reject on Mail From Fail
# - [SPF_Not_Pass] : reject if result not Pass, None, Tempfail
# - [Softfail] : reject on Mail From Softfail or Fail
# - [False] : never reject on Mail From, append header only
# - [No_Check] : never check Mail From/Return Path
Mail_From_reject = Fail

# Permanent Error Processing
# - [True] : reject the message if the SPF result (for HELO or Mail From) is PermError
# - [False] : treat PermError the same as no SPF record at all
PermError_reject = False

# Temporary Error Processing
# - [True] :  defer the message if the SPF result (for HELO or Mail From) is TempError
# - [False] : treat TempError the same as no SPF record at all
TempError_Defer = False

# skip addresses to skip SPF checking
skip_addresses = 127.0.0.0/8,::ffff:127.0.0.0/104,::1

root@mail:~# vi /usr/local/etc/postfix/master.cf
# add to last line
policyd-spf  unix  -       n       n       -       0       spawn
  user=nobody argv=/usr/local/bin/policyd-spf

root@mail:~# vi /usr/local/etc/postfix/main.cf
# add into [smtpd_recipient_restrictions]
smtpd_recipient_restrictions = 
  permit_mynetworks,
  permit_sasl_authenticated,
  reject_unauth_destination,
  check_policy_service unix:private/policyd-spf

# add time limit
# * if this parameter is not specified, 
# the same value as [command_time_limit] (default is 1000s) is applied
policyd-spf_time_limit = 3600

root@mail:~# service postfix reload
```
[2]	Send an email to your own email address from Gmail or similar, and if the header shows [Received-SPF: Pass (mailfrom) ***] then everything is OK.