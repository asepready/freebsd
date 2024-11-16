Apache httpd : Configure mod_security
 	
Enable [mod_security] module to configure Web Application Firewall (WAF).

[1]	Install [mod_security].
```sh
root@www:~# pkg install -y ap24-mod_security
```
[2]	Enable [mod_security].
```sh
root@www:~# vi /usr/local/etc/apache24/modules.d/280_mod_security.conf
# uncomment all
LoadModule unique_id_module libexec/apache24/mod_unique_id.so
LoadModule security2_module libexec/apache24/mod_security2.so
Include /usr/local/etc/modsecurity/*.conf
root@www:~# vi /usr/local/etc/modsecurity/modsecurity.conf
    # line 7 : [SecRuleEngine DetectionOnly] is set as default, it does not block actions
    # if you like to block actions, change to [SecRuleEngine On]
    SecRuleEngine DetectionOnly
.....
.....
```
[3]	It's possible to write a rule like follows. ⇒ SecRule VARIABLES OPERATOR [ACTIONS] Each parameter has many kind of values, refer to official documents below. https://github.com/SpiderLabs/ModSecurity/wiki

[4]	For Example, set some rules and verify it works normally.
```sh
root@www:~# vi /usr/local/etc/modsecurity/localrules.conf
# default action when matching rules
SecDefaultAction "phase:2,deny,log,status:406"
# [etc/passwd] is included in request URI
SecRule REQUEST_URI "etc/passwd" "id:'500001'"
# [../] is included in request URI
SecRule REQUEST_URI "\.\./" "id:'500002'"
# [<SCRIPT] is included in arguments
SecRule ARGS "<[Ss][Cc][Rr][Ii][Pp][Tt]" "id:'500003'"
# [SELECT FROM] is included in arguments
SecRule ARGS "[Ss][Ee][Ll][Ee][Cc][Tt][[:space:]]+[Ff][Rr][Oo][Mm]" "id:'500004'"
root@www:~# service apache24 restart
```
[5]	Access to the URI which includes words you set and verify it works normally. example : http://belajarfreebsd.or.id/?q=<script>

[6]	The logs for [mod_security] is placed in the directory like follows.
```sh
root@www:~# cat /var/log/modsec_audit.log
--0db23374-A--
[01/Feb/2024:14:03:53.922429 +0900] ZbsmOZG1oaXNG3gprGLB8wAAAAM 10.0.0.5 65030 10.0.0.31 443
--0db23374-B--
GET /?q=%3Cscript%3E HTTP/1.1
Host: www.srv.world
Connection: keep-alive
sec-ch-ua: "Not A(Brand";v="99", "Microsoft Edge";v="121", "Chromium";v="121"
sec-ch-ua-mobile: ?0
sec-ch-ua-platform: "Windows"
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Sec-Fetch-Site: none
Sec-Fetch-Mode: navigate
Sec-Fetch-User: ?1
Sec-Fetch-Dest: document
Accept-Encoding: gzip, deflate, br
Accept-Language: ja,en;q=0.9,en-GB;q=0.8,en-US;q=0.7
.....
.....
```