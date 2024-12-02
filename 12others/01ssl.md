# Create SSL Certificate (Self Signed)
Create Self Signed SSL Certificate by yourself.
It had better to use Self Signed Certificate on the environment for the purpose of testing, development, and so on. It's not recommended to use on production System.
```sh
root@nsx:~# ee /etc/ssl/openssl.cnf
# add to the end
# section name is any name you like
# DNS:(this server's hostname)
# if you set multiple hostname or domainname, set them with comma separated
# ⇒ DNS:nsx.srv.cnsa, DNS:www.srv.cnsa
[ srv.cnsa ]
subjectAltName = DNS:nsx.srv.cnsa

root@nsx:~# mkdir -p /usr/local/etc/ssl
root@nsx:~# cd /usr/local/etc/ssl
root@nsx:/usr/local/etc/ssl# openssl genrsa -aes128 2048 > server.key
Enter PEM pass phrase:                  # set passphrase
Verifying - Enter PEM pass phrase:      # confirm

# remove passphrase from private key
root@nsx:/usr/local/etc/ssl# openssl rsa -in server.key -out server.key
Enter pass phrase for server.key:   # input passphrase
writing RSA key

root@nsx:/usr/local/etc/ssl# openssl req -utf8 -new -key server.key -out server.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:ID                           # country code
State or Province Name (full name) []:KEP.BABEL                # state
Locality Name (eg, city) [Default City]:PANGKALPINANG          # city
Organization Name (eg, company) [Default Company Ltd]:EDU      # company
Organizational Unit Name (eg, section) []:Server INDO         # department
Common Name (eg, your name or your server's hostname) []:nsx.srv.cnsa  # server's FQDN
Email Address []:root@srv.cnsa                                # admin email address

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:

# create certificate with 10 years expiration date
# -extensions (section name) ⇒ the section name you set in [openssl.cnf]
root@nsx:/usr/local/etc/ssl# openssl x509 -in server.csr -out server.crt -req -signkey server.key -extfile /etc/ssl/openssl.cnf -extensions srv.cnsa -days 3650
Certificate request self-signature ok
subject=C = ID, ST = KEP.BABEL, L = PANGKALPINANG, O = EDU, OU = Server INDO, CN = nsx.srv.cnsa, emailAddress = root@srv.cnsa
root@nsx:/usr/local/etc/ssl# chmod 600 server.key
root@nsx:/usr/local/etc/ssl# ls -l server.*
-rw-r--r--  1 root wheel 1424 Dec 20 15:21 server.crt
-rw-r--r--  1 root wheel 1062 Dec 20 15:21 server.csr
-rw-------  1 root wheel 1704 Dec 20 15:20 server.key