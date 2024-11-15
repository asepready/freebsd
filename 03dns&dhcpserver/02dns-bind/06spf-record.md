BIND : Set SPF record
 	
Set up a Sender Policy Framework (SPF) record to verify the validity of the domain from which the email is sent.

This example is based on the environment that the [belajarfreebsd.or.id] domain uses the network range [172.16.0.80/29]. Replace the domain name to yours, and also replace [172.16.0.80/29] to the global IP address of yours.

[1]	Add a TXT record to the zone file that contains the target domain name and set SPF there.
```sh
root@belajarfreebsd:~# ee /usr/local/etc/namedb/primary/belajarfreebsd.or.id.wan
$TTL 86400
@   IN  SOA     ns.belajarfreebsd.or.id. root.belajarfreebsd.or.id. (
        ;; when updating a zone file, update the serial number as well
        2024071801 ;Serial
        3600       ;Refresh
        1800       ;Retry
        604800     ;Expire
        86400      ;Minimum TTL
)
        IN  NS     ns.belajarfreebsd.or.id.
        IN  A      172.16.0.82
        IN  MX 10  ns.belajarfreebsd.or.id.
        ;; add SPF settings to a TXT record
        ;; specify the host to use as the mail server
        IN  TXT    "v=spf1 +ip4:172.16.0.82 -all"

ns     IN  A      172.16.0.82
www     IN  A      172.16.0.83

root@belajarfreebsd:~# rndc reload
```
[2]	This is the basic description of SPF.
```sh
;; the TXT record itself can have multiple lines, 
;; but in SPF settings, only one TXT record can be set for one domain name

;; [v=spf1] ⇒ it means SPF version

;; [+ip4] ⇒ specify IPv4 addresses
;; [+ip6] ⇒ specify IPv6 addresses

;; [+] ⇒ verify your domain's mail server
;; * [+] is optional
;; * if there is no [+] or [-], the [+] is considered to be omitted

;; [-] ⇒ do not authenticate as a mail server for the domain
;; [~] ⇒ deemed to be potentially fake but delivered anyway

;; if there are multiple mail servers, specify them with a space separator
        IN  TXT    "v=spf1 +ip4:172.16.0.82 +ip4:172.16.0.83 -all"

;; for the case of specifying the host name of the mail server
;; * host name must be specified as a Fully Qualified Domain Name (FQDN)
        IN  TXT    "v=spf1 +a:ns.belajarfreebsd.or.id +a:www.belajarfreebsd.or.id -all"

;; for the case of setting only the specified host in the MX record
        IN  TXT    "v=spf1 +mx -all"

;; for the case of describing the network containing hosts that may send email using the CIDR method
;; * be careful, if you specify too broad a range, the SPF record will be meaningless
        IN  TXT    "v=spf1 +ip4:172.16.0.80/29 -all"

;; for example, if you use a subdomain such as [serverworld@ns.belajarfreebsd.or.id] as an email address,
;; set it for the subdomain
ns     IN  TXT    "v=spf1 +ip4:172.16.0.82 -all"

;; for example, if your domain is only used as a web server and does not send email at all,
;; you can declare this with the following settings
        IN  TXT    "v=spf1 -all"

;; for example, if you want to include the same SPF record as the one set for another domain [server.education],
;; set it like follows
        IN  TXT    "v=spf1 +include:server.education -all"
```
[3]	The following website allows you to check the contents of the SPF record you have set, so we recommend that you check it. ⇒ https://mxtoolbox.com/spf.aspx

If there are no problems with the SPF record settings, when you send an email to Gmail or others from the mail server of the configured domain, [SPF: PASS] will be displayed in the header.