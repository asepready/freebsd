

Generate a certificate that will be used in traefik to expose all container from a host to the url : https://*.lab.cloud. 

the '*' can then be replaced with a tag value in a label value on the containers.

The traefik management portal will be accessible via https://monitor.lab.cloud



1) Generate a root CA certificate

	- Generate the private key (named rooCA.key) that will be used to sign the root CA certificate

                openssl genrsa -out rootCA.key 2048

        - Request a root CA certificate signed by the rootCA.key

                openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem -batch -subj '/C=ID/L=Bangka Belitung/O=BABEL/OU=BABEL/CN=admin'

        - Add the root CA certificate (.pem) in the Trusted Root Certificate store. This will make the workstation to trust every certificate generated with the rootCa certificate
        - for RHEL : cp FLXCA.pem /etc/pki/ca-trust/source/anchors/ then sudo update-ca-trust extract check via openssl verify

2) Generate the certificate used in the SSL communication


   	- Generate the private key (named lab.cloud.key) that will be used to generate the Certificate Signing Request

		openssl genrsa -out lab.cloud.key 2048

	- Generate a Certificate Signing Request with the generated key
	
		openssl req -new -key lab.cloud.key -out lab.cloud.csr -batch -subj '/C=ID/L=Bangka Belitung/O=BABEL/OU=BABEL/CN=app.lab.cloud'

		During the generation a Common Name will be asked. Type *.lab.cloud

        - Create the certificate config file

                 Create a v3.ext file with the following content : 

			authorityKeyIdentifier=keyid,issuer
			basicConstraints=CA:FALSE
			keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
			subjectAltName = @alt_names

			[alt_names]
			DNS.1 = *.lab.cloud

	- Request a certificate with the geberated Certificate Signing Request ans the roo CA certificate

   		openssl x509 -req -in lab.cloud.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out lab.cloud.crt -days 500 -sha256 -extfile v3.ext



export to pfx openssl pkcs12 -export -out service.internal.lbtgdev.cloud.pfx -inkey service.internal.lbtgdev.cloud.key -in service.internal.lbtgdev.cloud.crt -certfile rootCAConsul.pem 


3) Set the Traefik configuration in traefik.toml

debug = false

logLevel = "ERROR"
defaultEntryPoints = ["https","http"]

[entryPoints]
  [entryPoints.http]
  address = ":80"
    [entryPoints.http.redirect]
    entryPoint = "https"
  [entryPoints.https]
  address = ":443"
    [entryPoints.https.tls]
      [[entryPoints.https.tls.certificates]]
      certFile = """-----BEGIN CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIDFjCCAf4CCQDk4/92qkFF8TANBgkqhkiG9w0BAQsFADBOMQswCQYDVQQGEwJB
VTETMBEGA1UECAwKU29tZS1TdGF0ZTEUMBIGA1UECgwLRGV2T3BzQ2xvdWQxFDAS
BgNVBAMMC0Rldk9wc0Nsb3VkMB4XDTE4MDMwMjIxNTEwN1oXDTE5MDcxNTIxNTEw
N1owTDELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxFDASBgNVBAoM
C0Rldk9wc0Nsb3VkMRIwEAYDVQQDDAlsYWIuY2xvdWQwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDYgU8JdpZi5F1pq0vrY2soJ+xc5QA0qHDL6KZGsm3a
bS3tEAMFAa+R2JdKAlqxyHdEA6AZZ3WZoARsil7urOcmxoeXNFkNdsj7QoG1rCf3
bfzw+8Dezr83zwQQ8DFTQGujLKlbbsfzcZh1+d3ohj/OmqokOQkr+jdD+N2lducg
xDtf7EytubjMqu4nH5RZnsjQpeOKrVExDg12XQQ8lYKa/SSd7XXl3xxTj7vKhE37
ZJwXTvH82RDGP5+aApzmetnQcC1yfWAL4AuJsVN8PKMXqMRN3LYoCNcdf3KnhxVS
j/K6pFaAb9vKwT9dcBbkgRUA5Bsgcmoi7fPRqkoYDBynAgMBAAEwDQYJKoZIhvcN
AQELBQADggEBAIXG0FZYQy0CN0c+PpuT5E0Zs6nAqHp17SXsn0z5lM2edWIBrS7O
YePo5C7+k/GOQ3MzryCcC2KMTZUptdnLwtWZVk6fgm0Fw4kShNvy3TBnDj6g19Ms
iRoS6TPJwOBaQ//XNidxpK/V3TfoAersA1bFsxLk7iv/EI7UrT5mcHJBOLpIhvH1
Y4o6ZSOcvrMEeItkKLupTLvH6b5rIvLKgUt74oVu/6dliioH/SR5YCsXYMtSk1Le
imYlIxI9iNkhTtXHg63LXWVBoYtnBW2YCBI8PDuD8/cZ59FXWapDmfltXVBkjdPv
p4KmMp/ATFE/6xmLXHr9ZXCTL32dD54lwDM=
-----END CERTIFICATE-----
                      -----END CERTIFICATE-----"""
      keyFile = """-----BEGIN CERTIFICATE-----
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA2IFPCXaWYuRdaatL62NrKCfsXOUANKhwy+imRrJt2m0t7RAD
BQGvkdiXSgJasch3RAOgGWd1maAEbIpe7qznJsaHlzRZDXbI+0KBtawn92388PvA
3s6/N88EEPAxU0BroyypW27H83GYdfnd6IY/zpqqJDkJK/o3Q/jdpXbnIMQ7X+xM
rbm4zKruJx+UWZ7I0KXjiq1RMQ4Ndl0EPJWCmv0kne115d8cU4+7yoRN+2ScF07x
/NkQxj+fmgKc5nrZ0HAtcn1gC+ALibFTfDyjF6jETdy2KAjXHX9yp4cVUo/yuqRW
gG/bysE/XXAW5IEVAOQbIHJqIu3z0apKGAwcpwIDAQABAoIBAQCLIsatWTWaRhI2
J2x50IF74/RFWrHAJYOft1qsUlzAo6uBDuox3Hx9KQlI+axZVnA3GHFaAiAUYz6U
lnQdxKYkSC+5H14fhffxaTM8km941olYQSIYzhsa/YIqdIHuc5b43WnVJaOAMr99
Cd/vX98/oiu3baQUTBAaMaQXgwtUBTjd2weSih1yrn3W6epppu0/WLjWUQ5NH121
n2VLOy/43dO6UGmC1njGl+5ZeXfQ3bTmvW3d+r0w2wj/6pMrJZ5/BDFYduDIBhnG
htYLkKwSdDCwuk3ayoQkHrwAruExHwXtZDt49gONCHfgwfwk9ZjCAs35gVXlz5Es
9NqeSuOxAoGBAPloEjv2BEb9Xy99tj5JEZEqchd0o5nfqBPkQi8ESw6MR26/cc+U
n8Rq855xrNG7OKVGN6jcpFTT/hZLY0xXqUuBdCzypeVzr5clDAnFlkm4IVSncFd4
T+J+g0tGS4LUZwo5WQUSiLw1GYxvgN+TIaN/h2Xx48/+bbJWdiEwnPjvAoGBAN46
kWP2bsWt8EHMeoxHmczSQ5++ntNIfVQpb42Fv/U6KjKSG7X0kMbck5lqOg/ByEgF
LIgebvtFxtD1Xv5YK3l0wcHmp6c9gG2bHy3Gb9dQnH2R5Zw8GURHiYKZuaYy3EXM
ZyIbyC6DO0r7osH239+lh90h94w10LVUoXG4o+fJAoGBAJ6rhR48j9ASFeKC2dSa
a+Cs3lTp0cNtNOMizrBWzOF+gVuF1IQ5i8NMP51HuKjdsVYEbBiz9qA5FmdcotnI
013ECAMohD6L8OP5n8T/vXM8/4d51tDvK/NuhVz4ZcXgF4W7olTFy9Pg/FYKAjU6
x6Xa1msXDtYeie9xbkoDQXplAoGACsoxMPdQHYz6c1doQ9NeJlG3MtRghcWpQCLa
5bYuwctXLSlm6wi61szy5aoAs68m+Eg4B0vi+5RBuPeQ6yyAv97pYW6/iSE1UR0N
AH34BC5HytkAmvtYBraqeIraNrWVeFYaU8+hgpCgml1pY52G9SbmV9hEWqxqO8Om
Kw1Z9/ECgYBchQx4VXBmsTZCVygwUfErzS8GIrk0iuSBsLHygYd4TRTwH4Zz+ML4
Ql1YPnaPpw50xVyKwMyRjoYCa41yf/GiLYxfJu7Q3Cu4KAV3P4gQ4yvzATPhsjkm
CrmdMRMIAyWtf6+Sf4EFUTiQfwFB/HoN2WfQyc+OnUqaRPnId4GRSQ==
-----END RSA PRIVATE KEY-----
                      -----END CERTIFICATE-----"""


4) Configure the monitoring portal

	- Generate the password hash

		apt-get install apache2-utils

		htpasswd -nb admin <secure_password>

	- Add this section to the traefik.toml

		[web]
                address = ":8080"
  		  [web.auth.basic]
  		  users = ["admin:your_encrypted_password"]


5) Configure the integration with Docker (Only Linux)

	- Add this configuration to traefik.toml

		[docker]
		endpoint = "unix:///var/run/docker.sock"
		domain = "lab.cloud"
		watch = true
		exposedbydefault = false
	
	Traefik will listen to the docker unix sock endpoint and update his routes (check the monitoring potal afteradding or removing a container on the host)

6) Deploy the traefik container with docker-compose

version: '2'
services:
  proxy:
    image: traefik:alpine
    command: --api
    networks:
      - webgateway
    labels:
      - traefik.frontend.rule=Host:monitor.lab.cloud
      - traefik.port=8080
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/configs/traefik/traefik.toml:/traefik.toml    
        
networks:
    webgateway:

7) Create a A Record on your DNS server with the value *.lab.cloud pointing to your server IP Adress