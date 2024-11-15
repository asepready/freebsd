BIND : Set DMARC record
 	
Configure a DMARC (Domain-based Message Authentication, Reporting, and Conformance) record to indicate that your mail server is protected by SPF/DKIM.

[1]	DMARC is a setting that registers in your DNS record what to do when SPF or DKIM authentication fails, and instructs the recipient of the email. Therefore, configure SPF record setting and DKIM setting on Mail server side in advance.

[2]	Configure a DMARC record in the zone file that contains the target domain name.
```sh
root@belajarfreebsd:~# vi /usr/local/etc/namedb/primary/belajarfreebsd.or.id.wan
$TTL 86400
@   IN  SOA     ns.belajarfreebsd.or.id. root.belajarfreebsd.or.id. (
        ;; update serial number
        2024071801 ;Serial
        3600       ;Refresh
        1800       ;Retry
        604800     ;Expire
        86400      ;Minimum TTL
)
        IN  NS     ns.belajarfreebsd.or.id.
        IN  A      172.16.0.82
        IN  MX 10  ns.belajarfreebsd.or.id.
        IN  TXT    "v=spf1 +ip4:172.16.0.82 -all"

dlp     IN  A      172.16.0.82
www     IN  A      172.16.0.83

20240712._domainkey     IN      TXT     "v=DKIM1; h=sha256; k=rsa; ""p=MIIBIjANBgkqh....."
;; add to last line
_dmarc  IN  TXT    "v=DMARC1; p=none;"

root@belajarfreebsd:~# rndc reload
```
[3]	Other options for your DMARC record.
```sh
;; [v=DMARC1] ⇒ DMARC version

;; [p=***] : action policy when authentication fails
;; - [none] ⇒ do nothing
;; - [quarantine] ⇒ quarantined in junk mail folder
;; - [reject] ⇒ reject email

;; [rua=mailto:***] : the address to which aggregate reports will be sent
;; * if not specified, no aggregate report will be sent
;; * if specify multiple addresses, separate them with commas (,)
_dmarc  IN  TXT    "v=DMARC1; p=none; rua=mailto:admin@belajarfreebsd.or.id,webmaster@belajarfreebsd.or.id"

;; [ruf=mailto:***] : the address to which failure reports will be sent
;; * if not specified, no failure report will be sent
;; * if specify multiple addresses, separate them with commas (,)
_dmarc  IN  TXT    "v=DMARC1; p=none; ruf=mailto:admin@belajarfreebsd.or.id,webmaster@belajarfreebsd.or.id"

;; [sp=***] : action policy when authentication of subdomain fails
;; * if not specified, the setting of [p=***] will be inherited
;; - [none] ⇒ do nothing
;; - [quarantine] ⇒ quarantined in junk mail folder
;; - [reject] ⇒ reject email
_dmarc  IN  TXT    "v=DMARC1; p=none; sp=reject; rua=mailto:admin@belajarfreebsd.or.id"

;; [pct=***] : percentage of emails that the policy covers
;; * specify with [1-100]
;; * if not specified, it is set to [pct=100]
_dmarc  IN  TXT    "v=DMARC1; p=none; pct=50; rua=mailto:admin@belajarfreebsd.or.id"

;; [fo=***] : action options for sending failure reports (when ruf=*** is enabled)
;; - [0] ⇒ both DKIM and SPF authentication fails (default if not specified)
;; - [1] ⇒ either DKIM or SPF authentication failed
;; - [d] ⇒ DKIM authentication failed
;; - [s] ⇒ SPF authentication failed

;; [aspf=***] : SPF authentication alignment mode
;; - [s] ⇒ strict mode : exact domain match (default if not specified)
;; - [r] ⇒ relaxed mode : partial domain match

;; [adkim=***] : DKIM authentication alignment mode
;; - [s] ⇒ strict mode : exact domain match (default if not specified)
;; - [r] ⇒ relaxed mode : partial domain match

;; [rf=afrf] : DMARC authentication failure report format
;; * currently only [rf=afrf] (default if not specified)

;; [ri=***] : aggregate report sending interval (in seconds)
;; * if not specified, the default value is [ri=86400] (24 hours)
```
[4]	The following website allows you to check the description of the DMARC record you have set, so it is a good idea to check it out. ⇒ https://mxtoolbox.com/dmarc.aspx

If there are no problems with the DMARC record settings, when you send an email from the mail server of the configured domain to Gmail etc., the header will show [DMARC: 'PASS'].