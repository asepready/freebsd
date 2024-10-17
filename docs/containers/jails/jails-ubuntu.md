Implementatasi Linux on FreeBSD Jail

base Linux Alpine:
```sh
# Enabling Linuxulator
service linux enable
service linux start

fetch http://cdimage.ubuntu.com/ubuntu-base/releases/noble/release/ubuntu-base-22.04-base-amd64.tar.gz -o /usr/local/jails/media/ubuntu-base-22.04-base-amd64.tar.gz

mkdir -p /usr/local/jails/containers/ubuntu
tar -xf /usr/local/jails/media/ubuntu-base-22.04-base-amd64.tar.gz -C /usr/local/jails/containers/ubuntu --unlink

echo "auto lo" > /usr/local/jails/containers/ubuntu/etc/network/interfaces
#mkdir /usr/local/jails/containers/ubuntu/run/openrc; touch /usr/local/jails/containers/ubuntu/run/openrc/softlevel

cp /etc/resolv.conf /usr/local/jails/containers/ubuntu/etc/resolv.conf
cp /etc/localtime /usr/local/jails/containers/ubuntu/etc/localtime

jail -crm \
  name=ubuntu \
  host.hostname="ubuntu" \
  path="/usr/local/jails/containers/ubuntu" \
  interface="re0" \
  ip4.addr="192.168.10.152" \
  exec.start="/bin/true" \
  exec.stop="/bin/true" \
  mount.devfs \
  devfs_ruleset=4 \
  allow.mount \
  allow.mount.devfs \
  allow.mount.fdescfs \
  allow.mount.procfs \
  allow.mount.linprocfs \
  allow.mount.linsysfs \
  allow.mount.tmpfs \
  enforce_statfs=1

```

Buat FIle /etc/jail.conf.d/ubuntu.conf
```sh
cat <<"EOF">> /etc/jail.conf.d/ubuntu.conf
ubuntu {
    host.hostname = "${name}";
    #exec.consolelog = "/var/log/jail_console_${name}.log";
    ip4.addr= 192.168.10.152;
    interface = re0;
    path="/usr/local/jails/containers/${name}";
    allow.raw_sockets=1;
    #exec.start='/sbin/openrc';
    exec.start='/bin/true';
    exec.stop='/bin/true';
    persist;
    mount.fstab="/usr/local/jails/containers/${name}.fstab";
}
"EOF"
```

Edit file pada /usr/local/jails/containers/ubuntu.fstab
```sh
cat <<"EOF">> /usr/local/jails/containers/ubuntu.fstab
devfs           /usr/local/jails/containers/ubuntu/dev      devfs           rw                      0       0
tmpfs           /usr/local/jails/containers/ubuntu/dev/shm  tmpfs           rw,size=1g,mode=1777    0       0
fdescfs         /usr/local/jails/containers/ubuntu/dev/fd   fdescfs         rw,linrdlnk             0       0
linprocfs       /usr/local/jails/containers/ubuntu/proc     linprocfs       rw                      0       0
linsysfs        /usr/local/jails/containers/ubuntu/sys      linsysfs        rw                      0       0
/tmp            /usr/local/jails/containers/ubuntu/tmp      nullfs          rw                      0       0
/home           /usr/local/jails/containers/ubuntu/home     nullfs          rw                      0       0
"EOF"
```

Test && Console
```sh
#Jalankan
jail -crm -f ubuntu.conf

# Login sebagai root 
jexec ubuntu login -f root

# test paket
apk add openrc
apk add ubuntu ubuntu-cli containerd ubuntu-compose

service ubuntu start
rc-update add ubuntu
```
Edit pada fIle  /etc/jail.conf.d/ubuntu.conf
```sh 
#exec.start='/bin/true';
exec.start='/sbin/openrc';
```

Restart Jails
```sh
jail -r ubuntu
jail -crm -f ubuntu.conf
```