HAProxy : ACL Settings (L4)
 	
This is the ACL Setting example. It's possible to use on Layer4 mode.

Refer to the official documents to see various usages.

⇒ https://www.haproxy.com/documentation/hapee/latest/onepage/#7.3.3

[1]	Change to Layer4 mode, refer to here.

[2]	Configure HAProxy.
By following settings, requests to [80] port is forwarded to the backend [10.0.0.31:80],
requests to [3306] port is forwarded to the backend [10.0.0.51:3306],
requests to [22] port is forwarded to the backend [10.0.0.52:22].
```sh
root@belajarfreebsd:~# vi /usr/local/etc/haproxy.conf
# add to last line
frontend mariadb-in
        bind *:3306
        # set ACL
        # destination port is [3306]
        acl dst_3306 dst_port 3306

        # set action for ACL
        use_backend mariadb_node01 if dst_3306

backend mariadb_node01
        server node01 10.0.0.51:3306 check

frontend ssh-in
        bind *:22
        acl dst_22 dst_port 22
        use_backend ssh_node02 if dst_22

backend ssh_node02
        server node02 10.0.0.52:22 check

frontend http-in
        bind *:80
        acl dst_80 dst_port 80
        use_backend http_www if dst_80

backend http_www
        server www 10.0.0.31:80 check

root@belajarfreebsd:~# service sshd stop
root@belajarfreebsd:~# service mysql-server stop
root@belajarfreebsd:~# service haproxy reload
[3]	Verify working normally to access to the frontend HAproxy Server with each service ports.
freebsd@client:~ $ mysql -u freebsd -p -h ns.belajarfreebsd.or.id -e "show variables like 'hostname';"
Enter password:
+---------------+------------------+
| Variable_name | Value            |
+---------------+------------------+
| hostname      | node01.belajarfreebsd.or.id |
+---------------+------------------+

freebsd@client:~ $ ssh freebsd@ns.belajarfreebsd.or.id hostname
(freebsd@ns.belajarfreebsd.or.id) Password for freebsd@node02.belajarfreebsd.or.id:
node02.belajarfreebsd.or.id

freebsd@client:~ $ curl http://ns.belajarfreebsd.or.id/
www.belajarfreebsd.or.id