Prometheus : Set Alert Notification (Email)
 	
This is the Alert Notification Settings on Prometheus.

There are many way to receive Alerts like Slack, HipChat, WeChat and others, though, on this example, Configure Alerting with Email Receiver.

For more details of Alerting, Refer to the official documents. ⇒ https://prometheus.io/docs/alerting/configuration/

[1]	For Email notification, it needs SMTP Server.
On this example, it based on the environment that SMTP Server is running on localhost.

[2]	Install Alertmanager on Prometheus Server Host.
```sh
root@belajarfreebsd:~# pkg install -y alertmanager
```
[3]	Configure Prometheus Alert Settings with Email notification.
```sh
root@belajarfreebsd:~# mv /usr/local/etc/alertmanager/alertmanager.yml /usr/local/etc/alertmanager/alertmanager.yml.org
root@belajarfreebsd:~# vi /usr/local/etc/alertmanager/alertmanager.yml
# create new
global:
  # SMTP server to use
  smtp_smarthost: 'localhost:25'
  # require TLS or not
  smtp_require_tls: false
  # notification sender's Email address
  smtp_from: 'Alertmanager <root@ns.belajarfreebsd.or.id>'
  # if set SMTP Auth on SMTP server, set below, too
  # smtp_auth_username: 'alertmanager'
  # smtp_auth_password: 'password'

route:
  # Receiver name for notification
  receiver: 'email-notice'
  # grouping definition
  group_by: ['alertname', 'Service', 'Stage', 'Role']
  group_wait:      30s
  group_interval:  5m
  repeat_interval: 4h

receivers:
# any name of Receiver
- name: 'email-notice'
  email_configs:
  # destination Email address
  - to: "root@localhost"

# configure Alerting rules
root@belajarfreebsd:~# vi /usr/local/etc/alertmanager/alert_rules.yml
# create new
# for example, monitor node-exporter's [Up/Down]
groups:
- name: Instances
  rules:
  - alert: InstanceDown
    expr: up == 0
    for: 5m
    labels:
      severity: critical
    annotations:
      description: '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.'
      summary: 'Instance {{ $labels.instance }} down'

root@belajarfreebsd:~# vi /usr/local/etc/prometheus.yml
# line 11 : add - (Alertmanager Host):(Port)
alerting:
  alertmanagers:
    - static_configs:
      - targets: ['localhost:9093']

# line 18 : add alert rules created above
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"
  - "alertmanager/alert_rules.yml"

root@belajarfreebsd:~# service alertmanager enable
root@belajarfreebsd:~# service alertmanager start
root@belajarfreebsd:~# service prometheus restart
```
[4]	If [node-exporter] is down, following Email is sent. (mail body is HTML)
```sh
root@belajarfreebsd:~# s-nail
Message 2:
From root@ns.belajarfreebsd.or.id  Fri Sep  6 13:08:25 2024
X-Original-To: root@localhost
Delivered-To: root@localhost
Subject: [FIRING:1] InstanceDown (node01.belajarfreebsd.or.id:9100 Hiroshima critical)
To: root@localhost
From: Alertmanager <root@ns.belajarfreebsd.or.id>
Date: Fri, 06 Sep 2024 13:08:25 +0900
Content-Type: multipart/alternative;  boundary=c71dabb8e1a23608cb2d4418baba4330a0380bca8d62c1313c11a678679e
MIME-Version: 1.0

--c71dabb8e1a23608cb2d4418baba4330a0380bca8d62c1313c11a678679e
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.=
.....
.....


.....
.....
```