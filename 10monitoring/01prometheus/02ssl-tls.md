Prometheus : Enable authentication and HTTPS2024/09/06
 	
Enable basic authentication and HTTPS for Prometheus endpoint.

[1]	Get SSL Certificate, or Create self-signed Certificate.
It uses self signed Certificate on this example.

[2]	Configure Prometheus.
```sh
root@belajarfreebsd:~# pkg install -y apache24
# generate password with bcrypt hash
# set any username you like
root@belajarfreebsd:~# htpasswd -nB admin
New password:
Re-type new password:
admin:$2y$05$.Ne.2SccDPsUYWquhSu3OOebB85g3pde/7nnrWmrIOnVw8x2KJDyS

root@belajarfreebsd:~# cp /usr/local/etc/ssl/server.crt /usr/local/etc/ssl/server.key /usr/local/etc/
root@belajarfreebsd:~# chown prometheus:prometheus /usr/local/etc/server.crt /usr/local/etc/server.key
root@belajarfreebsd:~# vi /usr/local/etc/prometheus-web.yml
# create new
# specify your certificate
tls_server_config:
  cert_file: /usr/local/etc/server.crt
  key_file: /usr/local/etc/server.key

# specify username and password generated above
basic_auth_users:
  admin: $2y$05$.Ne.2SccDPsUYWquhSu3OOebB85g3pde/7nnrWmrIOnVw8x2KJDyS

root@belajarfreebsd:~# vi /usr/local/etc/prometheus.yml
.....
.....
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
    # add settings for certificate and authentication
    scheme: https
    tls_config:
      cert_file: /usr/local/etc/server.crt
      key_file: /usr/local/etc/server.key
      # if using self-signed certificate, set [true]
      insecure_skip_verify: true
    basic_auth:
      username: 'admin'
      password: 'password'

    static_configs:
      # if using valid certificate, set the same hostname in certificate
      - targets: ["localhost:9090"]

root@belajarfreebsd:~# sysrc prometheus_args="--web.config.file=/usr/local/etc/prometheus-web.yml"
prometheus_args: -> --web.config.file=/usr/local/etc/prometheus-web.yml
root@belajarfreebsd:~# service prometheus restart
```
[3]	Access to Prometheus endpoint via HTTPS, then that's OK if you can successfully authenticate with the username and password you set.

