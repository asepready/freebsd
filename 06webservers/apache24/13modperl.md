Apache httpd : Configure mod_perl2024/02/01
 	
Install [mod_perl] to make Perl scripts be fast.

[1]	Install [mod_perl].
```sh
root@www:~ # pkg install -y ap24-mod_perl2
```
[2]	Configure [PerlRun] mode which always put Perl interpreter on RAM.
```sh
root@www:~ # vi /usr/local/etc/apache24/modules.d/260_mod_perl.conf
# uncomment
LoadModule perl_module libexec/apache24/mod_perl.so
root@www:~ # vi /usr/local/etc/apache24/Includes/mod_perl.conf
# create new
# for example, set PerlRun mode under the "/usr/local/www/apache24/perl"
PerlSwitches -w
PerlSwitches -T

Alias /perl /usr/local/www/apache24/perl
<Directory /usr/local/www/apache24/perl>
    AddHandler perl-script .cgi .pl
    PerlResponseHandler ModPerl::PerlRun
    PerlOptions +ParseHeaders
    Options FollowSymLinks ExecCGI
    AllowOverride All
    Require all granted
</Directory>

<Location /perl-status>
    SetHandler perl-script
    PerlResponseHandler Apache2::Status
    Require ip 127.0.0.1 10.0.0.0/24
</Location>

root@www:~ # service apache24 reload
```
[3]	Create a test Script to make sure the settings are no problem. It's OK if the result like follows is displayed.
```sh
root@www:~ # mkdir /usr/local/www/apache24/perl
root@www:~ # vi /usr/local/www/apache24/perl/test-mod_perl.cgi
#!/usr/bin/perl

use strict;
use warnings;

print "Content-type: text/html\n\n";

my $a = 0;
&number();

sub number {
    $a++;
    print "number \$a = $a \n";
}

root@www:~ # chmod 705 /usr/local/www/apache24/perl/test-mod_perl.cgi
root@www:~ # curl localhost/perl/test-mod_perl.cgi
number $a = 1
```
[4]	Configure [Registry] mode which has caches of executed codes on RAM.
```sh
root@www:~ # vi /usr/local/etc/apache24/Includes/mod_perl.conf
Alias /perl /usr/local/www/apache24/perl
<Directory /usr/local/www/apache24/perl>
    AddHandler perl-script .cgi .pl
    # comment out PerlRun mode and add Registry mode like follows
    #PerlResponseHandler ModPerl::PerlRun
    PerlResponseHandler ModPerl::Registry
    PerlOptions +ParseHeaders
    Options FollowSymLinks ExecCGI
    AllowOverride All
    Require all granted
</Directory>

root@www:~ # service apache24 reload
```
[5]	Access to the test script which is an example of [3] section, then variable increases by reloading because variable is cached on RAM. So it's necessarry to edit the code for Registry mode.
```sh
root@www:~ # curl localhost/perl/test-mod_perl.cgi
number $a = 1
root@www:~ # curl localhost/perl/test-mod_perl.cgi
number $a = 2
root@www:~ # curl localhost/perl/test-mod_perl.cgi
number $a = 3
root@www:~ # vi /usr/local/www/apache24/perl/test-mod_perl.cgi
#!/usr/bin/perl

use strict;
use warnings;

print "Content-type: text/html\n\n";

my $a = 0;
&number($a);

sub number {
    my($a) = @_;
    $a++;
    print "number \$a = $a \n";
}

root@www:~ # curl localhost/perl/test-mod_perl.cgi
number $a = 1
root@www:~ # curl localhost/perl/test-mod_perl.cgi
number $a = 1
root@www:~ # curl localhost/perl/test-mod_perl.cgi
number $a = 1
```
[6]	By the way, it's possible to see the status of [mod_perl] to access to [(your hostname or IP address)/perl-status].

