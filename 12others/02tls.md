Get SSL Certificates (Let's Encrypt)

Get SSL Certificates from Let's Encrypt who provides Free SSL Certificates.

Refer to the details for Let's Encrypt official site below.
⇒ https://letsencrypt.org/
The expiration date of a cert is 90 days.
However, Systemd Timer which checks and updates certificates is included in Certbot package and you don't need to update manually.

[1]	Install Certbot Client which is the tool to get certificates from Let's Encrypt.
```sh
root@nsx:~ # pkg install -y py311-certbot
```
[2]	Get certificates.
It needs Web server like Apache httpd or Nginx must be running on the server you work.
If no Web server is running, skip this section and Refer to [3] section.
Furthermore, it needs that it's possible to access from the Internet to your working server on port 80 because of verification from Let's Encrypt.
```sh
# for the option [--webroot], use a directory under the webroot on your server as a working temp
# -w [document root] -d [FQDN you'd like to get certs]
# FQDN (Fully Qualified Domain Name) : Hostname.Domainname
# if you'd like to get certs for more than 2 FQDNs, specify all like below
# ex : if get [srv.cnsa] and [www.srv.cnsa]
# ⇒ [-d srv.cnsa -d nsx.srv.cnsa]
root@nsx:~ # certbot certonly --webroot -w /usr/local/www/apache24/data -d dns.srv.cnsa
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Enter email address (used for urgent renewal and security notices)
# for the initial use, you need to register your email address
# specify your valid email address
 (Enter 'c' to cancel): root@mail.srv.cnsa

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please read the Terms of Service at
https://letsencrypt.org/documents/LE-SA-v1.3-September-21-2022.pdf. You must
agree in order to register with the ACME server. Do you agree?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# agree to the terms of use
(Y)es/(N)o: Y

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing, once your first certificate is successfully issued, to
share your email address with the Electronic Frontier Foundation, a founding
partner of the Let's Encrypt project and the non-profit organization that
develops Certbot? We'd like to send you email about our work encrypting the web,
EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: Y
Account registered.
Requesting a certificate for dns.srv.cnsa

Successfully received certificate.
Certificate is saved at: /usr/local/etc/letsencrypt/live/dns.srv.cnsa/fullchain.pem
Key is saved at:         /usr/local/etc/letsencrypt/live/dns.srv.cnsa/privkey.pem
This certificate expires on 2024-03-19.
These files will be updated when the certificate renews.

NEXT STEPS:
- The certificate will need to be renewed before it expires. Certbot can automatically renew the certificate in the background, but you may need to take steps to enable that functionality. See https://certbot.org/renewal-setup for instructions.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# success if [Successfully received certificate] is shown
# certs are created under the [/etc/letsencrypt/live/(FQDN)/] directory

# cert.pem       ⇒ SSL Server cert(includes public-key)
# chain.pem      ⇒ intermediate certificate
# fullchain.pem  ⇒ combined file cert.pem and chain.pem
# privkey.pem    ⇒ private-key file
[3]	If no Web Server is running on your working server, it's possible to get certs with using Certbot's Web Server feature. Anyway, it needs that it's possible to access from the Internet to your working server on port 80 because of verification from Let's Encrypt.
# for the option [--standalone], use Certbot's Web Server feature
# -d [FQDN you'd like to get certs]
# FQDN (Fully Qualified Domain Name) : Hostname.Domainname
# if you'd like to get certs for more than 2 FQDNs, specify all like below
# ex : if get [srv.cnsa] and [www.srv.cnsa] ⇒ specify [-d srv.cnsa -d www.srv.cnsa]
root@nsx:~ # certbot certonly --standalone -d rx-9.srv.cnsa
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Requesting a certificate for rx-9.srv.cnsa

Successfully received certificate.
Certificate is saved at: /usr/local/etc/letsencrypt/live/rx-9.srv.cnsa/fullchain.pem
Key is saved at:         /usr/local/etc/letsencrypt/live/rx-9.srv.cnsa/privkey.pem
This certificate expires on 2024-03-19.
These files will be updated when the certificate renews.

NEXT STEPS:
- The certificate will need to be renewed before it expires. Certbot can automatically renew the certificate in the background, but you may need to take steps to enable that functionality. See https://certbot.org/renewal-setup for instructions.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[4]	For Updating existing certs manually, use [renew] subcommand.
To run [renew] subcommand, all certs which have less than 30 days expiration are updated.
If you want to update certificates that have more than 30 days expiration, add [--force-renew] option.
Additionally, the Certbot package comes with an update script that you can enable to auto-update.
# for manual update, run like follows
root@nsx:~ # certbot renew
# package comes with update script
root@nsx:~ # ls -l /usr/local/etc/periodic/weekly/500.certbot-3.9
-r-xr-xr-x  1 root wheel 2494 Dec 13 07:53 /usr/local/etc/periodic/weekly/500.certbot-3.9

# to enable update script, set like follows
root@nsx:~ # vi /etc/periodic.conf
# create new
weekly_certbot_enable="YES"
[5]	If you like to convert certificates to PKCS12 (PFX) format for Windows, do like follows.
root@nsx:~ # openssl pkcs12 -export -in fullchain.pem -inkey privkey.pem -out nsx_for_iis.pfx
Enter Export Password:     # set any export password
Verifying - Enter Export Password: