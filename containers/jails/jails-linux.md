Implementatasi Linux on FreeBSD Jail

base Linux Alpine:
```sh
# Enabling Linuxulator
service linux enable
service linux start

fetch https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-minirootfs-3.20.3-x86_64.tar.gz -o /usr/local/jails/media/alpine-minirootfs-3.20.3-x86_64.tar.gz

mkdir -p /usr/local/jails/containers/docker
tar -xf /usr/local/jails/media/alpine-minirootfs-3.20.3-x86_64.tar.gz -C /usr/local/jails/containers/docker --unlink

echo "auto lo" > /usr/local/jails/containers/docker/etc/network/interfaces
mkdir /usr/local/jails/containers/docker/run/openrc; touch /usr/local/jails/containers/docker/run/openrc/softlevel

cp /etc/resolv.conf /usr/local/jails/containers/docker/etc/resolv.conf
cp /etc/localtime /usr/local/jails/containers/docker/etc/localtime
```

Buat FIle  /etc/jail.conf.d/docker.conf
```sh
docker {
    host.hostname = "${name}";
    #exec.consolelog = "/var/log/jail_console_${name}.log";
    ip4.addr= 192.168.10.151;
    interface = re0;
    path="/usr/local/jails/containers/${name}";
    allow.raw_sockets=1;
    #exec.start='/sbin/openrc';
    exec.start='/bin/true';
    exec.stop='/bin/true';
    persist;
    mount.fstab="/usr/local/jails/containers/${name}.fstab";
}
```

Edit file pada /usr/local/jails/containers/docker/etc/fstab
```sh
cat <<"EOF">> /usr/local/jails/containers/docker.fstab
devfs           /usr/local/jails/containers/docker/dev      devfs           rw                      0       0
tmpfs           /usr/local/jails/containers/docker/dev/shm  tmpfs           rw,size=1g,mode=1777    0       0
fdescfs         /usr/local/jails/containers/docker/dev/fd   fdescfs         rw,linrdlnk             0       0
linprocfs       /usr/local/jails/containers/docker/proc     linprocfs       rw                      0       0
linsysfs        /usr/local/jails/containers/docker/sys      linsysfs        rw                      0       0
"EOF"
```

Test && Console
```sh
#Jalankan
jail -crm -f docker.conf

# Login sebagai root 
jexec docker login -f root

# test paket
apk add openrc
apk add docker docker-cli containerd docker-compose

service docker start
rc-update add docker
```
Edit pada fIle  /etc/jail.conf.d/docker.conf
```sh 
#exec.start='/bin/true';
exec.start='/sbin/openrc';
```

Restart Jails
```sh
jail -r docker
jail -crm -f docker.conf
```