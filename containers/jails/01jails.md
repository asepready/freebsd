Implementatasi FreeBSD Jail
```sh
bsdinstall jail /home/jails/www
```
Buat FIle  /etc/jail.conf.d/www.conf
```sh
www {
  # STARTUP/LOGGING
  exec.start = "/bin/sh /etc/rc";
  exec.stop = "/bin/sh /etc/rc.shutdown";
  exec.consolelog = "/var/log/jail_console_${name}.log";

  # PERMISSIONS
  allow.raw_sockets;
  exec.clean;
  mount.devfs;

  # HOSTNAME/PATH
  host.hostname = "${name}";
  path = "/usr/local/jails/containers/${name}";

  # NETWORK
  ip4 = inherit;
  interface = em0;
}
```
Test && Console
```sh
sysrc jail_enable="YES"
sysrc jail_parallel_start="YES"
sysrc jail_list=””

service jail start www
jexec 1 csh

#Remove Jails
chflags -R noschg *
rm -rf www
```
