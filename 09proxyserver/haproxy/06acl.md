HAProxy : ACL Settings
 	
It's possible to distribute requests to backend servers according to rules to set HAProxy ACL.

This example is based on the environment like follows.
It needs you set DNS to receive requests of hostnames or domainnames you set ACL on HAProxy server.
```sh
-----------------+------------------+
                 |                  |
                 |10.0.0.30         |
+----------------+-------------+    |
| [ dlp.belajarfreebsd.or.id ] |    |
|            HAProxy           |    |
+------------------------------+    |
                                    |
-----------------+------------------+-----------------+----------
                 |                  |                 |          
                 |10.0.0.51         |                 |10.0.0.52 
+----------------+----------------+ | +----------------+----------------+
| [ node01.belajarfreebsd.or.id ] | | | [ node02.belajarfreebsd.or.id ] |
|           Web Server#1          | | |           Web Server#2          |
+---------------------------------+ | +---------------------------------+
                                    |
-----------------+------------------+-----------------+----------
                 |                                    |          
                 |10.0.0.53                           |10.0.0.31 
+----------------+----------------+   +---------------+-----------------+
| [ node03.belajarfreebsd.or.id ] |   |  [ www.belajarfreebsd.or.id ]   |
|           Web Server#3          |   |          Web Server#4           |
+---------------------------------+   +---------------------------------+
```
[1]	The syntax of ACL is like follows.

acl <aclname> <criterion> [flags] [operator] [<value>] ...

For <aclname>, specify any ACL name you like, for [operator], some criteria support an operator.
For others, see official documents below. ⇒ https://www.haproxy.com/documentation/hapee/latest/onepage/#7.3.6

Follows are the list of criteria and flags that are expected to be often used.

| criterion	| description |
| -- | -- |
| path	| extracts the request's URL path |
| query | extracts the request's query string |
| hdr | returns the last comma-separated value of the header in an HTTP request |
| src | the source IP address of the client of the session |
|  | possible to use on L4 mode |
| dst_port | the destination TCP port |
|  | possible to use on L4 mode only |
| -- | -- |

| flags | description |
| -- | -- |
| -i | ignore case |
| -f | load patterns from a file |
| -m | specify pattern matching method |
|  | refer to the right table for methods |
| -n | forbid the DNS resolutions |
| -u | force the unique ID of the ACL |
| -- | -- |

| method | description |
| -- | -- |
| bool | check the value as a boolean |
| beg | match the value that begins with the provided patterns |
| end | match the value that ends with the provided patterns |
| int | match the value as an integer |
| ip | match the value as IP addresses |
| len | match the value as provided length |
| reg | match the value with regular expressions |
| str | check the value as a string |
| sub | match the value that contains the provided patterns |
| -- | -- |

[2]	Configure HAProxy.
```sh
root@dlp:~ # vi /usr/local/etc/haproxy.conf
# add to last line
frontend http-in
        bind *:80

        # set ACL
        # [Host] in HTTP request header is [node01.belajarfreebsd.or.id]
        acl host_node01 hdr(Host) -i node01.belajarfreebsd.or.id

        # [Host] in HTTP request header begins with [node02]
        acl host_node02 hdr_beg(Host) -i node02

        # [Host] in HTTP request header contains [develop]
        acl host_node03 hdr_sub(Host) -i develop

        # domain name of [Host] in HTTP request header is [virtual.host]
        acl host_virtual_host hdr_dom(Host) -i virtual.host

        # PATH in HTTP request begins with [/work]
        acl path_workdir path -m beg /work

        # PATH in HTTP request contains [test]
        acl path_testdir path_sub -i test

        # query in HTTP request contains [script]
        acl query_script query -m sub script

        # source client IP address is [10.0.0.5/32]
        acl src_ip src -m ip 10.0.0.5/32

        # set action for each ACL
        use_backend www_node01 if host_node01 || path_workdir
        use_backend www_node02 if host_node02 || path_testdir
        use_backend www_node03 if host_node03 || query_script
        use_backend www_default if host_virtual_host || src_ip
        default_backend www_default

backend www_node01
        server node01 10.0.0.51:80 check

backend www_node02
        server node02 10.0.0.52:80 check

backend www_node03
        server node03 10.0.0.53:80 check

backend www_default
        server www_default 10.0.0.31:80 check

root@dlp:~ # service haproxy reload
```
[3]	Verify working normally to access to the frontend HAproxy Server with each matching pattern.
