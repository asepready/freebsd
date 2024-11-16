Apache httpd : Log Report : AWStats
 	
Install AWStats to report httpd access logs.

[1]	Install and Configure AWstats.
```sh
root@www:~# pkg install -y awstats
root@www:~# cp /usr/local/www/awstats/cgi-bin/awstats.model.conf /usr/local/www/awstats/cgi-bin/awstats.`hostname`.conf
root@www:~# vi /usr/local/www/awstats/cgi-bin/awstats.`hostname`.conf
# line 50 : change to the log file you like to report
LogFile="/var/log/virtual.host-access_log"
# line 126 : set [1] if httpd log format is [combined]
# for [common], set [4]
LogFormat=1
# line 157 : set hostname
SiteDomain="www.srv.world"
# line 172 : set domains or IP addresses you'd like to exclude on reports
HostAliases="localhost 127.0.0.1 REGEX[^.*www\.srv\.world$]"
root@www:~# cp /usr/local/share/doc/awstats/httpd_conf /usr/local/etc/apache24/Includes/awstats.conf
root@www:~# vi /usr/local/etc/apache24/Includes/awstats.conf
# create new
<Directory "/usr/local/www/awstats">
    Options None
    AllowOverride None
    #Order allow,deny
    #Allow from all
    # access permission for your local network
    Require ip 127.0.0.1 10.0.0.0/24
</Directory>

root@www:~# vi /usr/local/etc/apache24/httpd.conf
<IfModule !mpm_prefork_module>
        # line 166 : uncomment below if httpd is running in except [prefork] mode
        LoadModule cgid_module libexec/apache24/mod_cgid.so
</IfModule>
<IfModule mpm_prefork_module>
        # line 169 : uncomment below if httpd is running in [prefork] mode
        #LoadModule cgi_module libexec/apache24/mod_cgi.so
</IfModule>

root@www:~# service apache24 reload
# generate reports
root@www:~# /usr/local/www/awstats/cgi-bin/awstats.pl -config=`hostname` -update
Create/Update database for config "/usr/local/www/awstats/cgi-bin/awstats.www.srv.world.conf" by AWStats version 7.9 (build 20230108)
From data in log file "/var/log/virtual.host-access_log"...
Phase 1 : First bypass old records, searching new record...
Direct access after last parsed record (after line 6)
Jumped lines in file: 6
 Found 6 already parsed records.
Parsed lines in file: 5
 Found 0 dropped records,
 Found 0 comments,
 Found 0 blank records,
 Found 0 corrupted records,
 Found 0 old records,
 Found 5 new qualified records.
```
[2]	Access to the URL [(your server's name or IP address/)/awstats/awstats.pl] from any client computer on allowed network with web browser. Then you can see http access reports.
