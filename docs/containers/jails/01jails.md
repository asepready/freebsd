Implementatasi FreeBSD Jail
```sh
# ZFS
zfs create -o mountpoint=/usr/local/jails zroot/jails; mkdir /usr/local/jails/etc
zfs create zroot/jails/media
zfs create zroot/jails/templates
zfs create zroot/jails/containers

# UFS 
mkdir /usr/local/jails/
mkdir /usr/local/jails/media
mkdir /usr/local/jails/templates
mkdir /usr/local/jails/containers
```

base FreeBSD:
```sh
fetch https://download.freebsd.org/ftp/releases/amd64/amd64/13.4-RELEASE/base.txz -o /usr/local/jails/media/13.4-RELEASE-base.txz

mkdir -p /usr/local/jails/containers/classic
tar -xf /usr/local/jails/media/13.4-RELEASE-base.txz -C /usr/local/jails/containers/classic --unlink

cp /etc/resolv.conf /usr/local/jails/containers/classic/etc/resolv.conf
cp /etc/localtime /usr/local/jails/containers/classic/etc/localtime

freebsd-update -b /usr/local/jails/containers/classic/ fetch install
```
Buat FIle  /etc/jail.conf.d/classic.conf
```sh
classic {
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
  ip4.addr = 192.168.1.151;
  interface = em0;
}
```
Test && Console
```
service jail start classic
jexec 1 csh

sysrc jail_list=”www mysql”
```
