## Generate Key
```sh
openssl genpkey -algorithm RSA -out private.key -pkeyopt rsa_keygen_bits:4096
```
## Sertifikat self-signed dari kunci privat 
```sh
openssl req -new -x509 -sha256 -key private.key -out certificate.crt -days 365
```