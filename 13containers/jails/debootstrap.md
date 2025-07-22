
1. Install the tool Debootstrap, which installs Debian in a subdirectory of another system.
    Code:
```sh
    portsnap fetch update 
    portmaster sysutils/debootstrap #or
    pkg install debootstrap
```
2. Configure the file system where we will install the Jail.
    Code:
```sh
    zfs create -o mountpoint=/usr/local/jails zroot/jails
    zfs create zroot/jails/media
    zfs create zroot/jails/templates
    zfs create zroot/jails/containers
    mkdir /usr/local/jails/etc
```
3. Load the necessary modules.
    Code:
```sh
    kldload fdescfs linprocfs linsysfs tmpfs
```
4. We enable jail support and compatibility with Linux.
    Code:
```sh
sysrc jail_enable="YES"
sysrc jail_parallel_start="YES"
sysrc jail_list=
sysrc linux_enable="YES"
```
5. Only if installing Squeeze, change the compatibility level declared 2.6.18.
    Code:
```sh
sysctl compat.linux.osrelease=6.10.12
```
6. Include in the configuration file /etc/jail.conf.d/, change the IP address at your convenience:
    Code:
```sh
deb-master {
  path = /jailz/deb-master;
  allow.mount;
  mount.devfs;
  host.hostname = deb-master;
  mount.fstab="/usr/local/jails/etc/fstab.deb-master";
  ip4.addr = [B]127.0.0.10[/B];
  interface = lo0;
  exec.start = "/etc/init.d/rc 3";
  exec.stop = "/etc/init.d/rc 0";
}
```
7. Define the mounting points for the jail in /usr/local/jails/etc/fstab.dev-master:
    Code:
```sh
    linsys   /jailz/deb-master/sys         linsysfs  rw          0 0
    linproc  /jailz/deb-master/proc        linprocfs rw          0 0
    tmpfs    /jailz/deb-master/lib/init/rw tmpfs     rw,mode=777 0 0
```
8. With debootstrap install Debian GNU/Linux, Lenny or Squeeze versions, in the path of the jail.
    Code:
```sh
    debootstrap [B]--foreign --arch=i386[/B] lenny /jailz/deb-master http://archive.debian.org/debian/
    I: Retrieving Release
    W: Cannot check Release signature; keyring file not available /usr/share/keyring
    s/debian-archive-keyring.gpg
    I: Retrieving Packages
    I: Validating Packages
    I: Resolving dependencies of required packages...
    I: Resolving dependencies of base packages...
    I: Checking component main on http://archive.debian.org/debian...
    I: Retrieving libacl1 2.2.47-2
    I: Validating libacl1 2.2.47-2
    I: Retrieving adduser 3.110
    I: Validating adduser 3.110
    I: Retrieving apt-utils 0.7.20.2+lenny2
    I: Validating apt-utils 0.7.20.2+lenny2
    I: Retrieving apt 0.7.20.2+lenny2
    [B]....[/B]
    I: Extracting login...
    I: Extracting passwd...
    I: Extracting libslang2...
    I: Extracting initscripts...
    I: Extracting sysv-rc...
    I: Extracting sysvinit-utils...
    I: Extracting sysvinit...
    I: Extracting tar...
    I: Extracting tzdata...
    I: Extracting bsdutils...
    I: Extracting mount...
    I: Extracting util-linux...
    I: Extracting zlib1g...
```
9. Inside the jail, delete the configuration files sysvinit_*.
    Code:
```sh
    root@morsa:/jailz/etc # ls /jailz/deb-master/var/cache/apt/archives/sysvinit_*
    /jailz/deb-master/var/cache/apt/archives/sysvinit_2.86.ds1-61_i386.deb
    root@morsa:/jailz/etc # rm /jailz/deb-master/var/cache/apt/archives/sysvinit_*
```
10. We mount the filesystems of the jail, in this case, takes place after installation with debootstrap.
    Code:
```sh
    mount -t linprocfs none /jailz/deb-master/proc
    mount -t devfs none /jailz/deb-master/dev
    mount -t linsysfs none /jailz/deb-master/sys
    mount -t tmpfs none /jailz/deb-master/lib/init/rw
```
11. Run a shell with chroot within the path of the jail.
    Code:
```sh
    chroot /jailz/deb-master /bin/bash
```

12. To complete the configuration of the jail, from the shell started in the chroot environment, run:
    Code:
```sh
    I have no name!@morsa:/# dpkg --force-depends -Ei /var/cache/apt/archives/*.deb
```

13. We left the previous shell and unmount the previously mounted file systems in step 10.
    Code:
```sh
    umount /jailz/deb-master/proc
    umount /jailz/deb-master/dev
    umount /jailz/deb-master/sys
    umount /jailz/deb-master/lib/init/rw
```

In the likely event that can not be unmounted /jailz/deb-master/dev because the filesystem is busy, run:
    Code:
```sh
    # fstat | grep deb-master # kill -9 PID (For each process listed in the previous step)
```

    Never start the jail without cleaning the processes and unmounting /jailz/deb-master/dev.
14. You need to disable rsyslog inside the jail, because it is not supported by the Linux compatibility module. Therefore, before starting the jail, for each directory in the path /jailz/deb-master/etc/rcX.d (where X takes values from 0 to 6) rename the service startup scripts.
    Code:
```sh
    # mv S10rsyslog _S10rsyslog
    # mv K90rsyslog _K90rsyslog
```
15. Start the jail, check that is correctly started and login.
    Code:
```sh
    jail -f /usr/local/jails/etc/jail.conf -c deb-master
    deb-master: created
    Starting periodic command scheduler: crond.

    jls
       JID  IP Address      Hostname                      Path
         1  127.0.0.10      deb-master                   /jailz/deb-master

    jexec 1 /bin/bash
    deb-master:/# uname -a
    Linux deb-master 2.6.16 FreeBSD 9.1-RELEASE-p4 #0: Mon Jun 17 11:42:37 UTC 2013 i686 GNU/Linux
```
16. Edit the file /etc/apt/sources.list and correct their content.
    Code:
```sh
    http://archive.debian.org/debian/ deb lenny main contrib non-free
```

17. Update the package list.
    Code:
```sh
    deb-master:/# apt-get update
    Get:1 http://archive.debian.org lenny Release.gpg [1034B]
    Get:2 http://archive.debian.org lenny Release [99.6kB]
    Get:3 http://archive.debian.org lenny/main Packages [6872kB]
    Get:4 http://archive.debian.org lenny/non-free Packages [124kB]
    Get:5 http://archive.debian.org lenny/contrib Packages [94.3kB]
    Fetched 7191kB in 11s (649kB/s)
    Reading package lists... Done
```

18. Shutdown the jail, the error messages are due to processes within the jail can not perform certain operations.
    Code:
```sh
    jail -f /usr/local/jails/etc/jail.conf -r deb-master
    umount2: Operation not permitted
    umount: fbsdzpool1/jailz: must be superuser to umount
    umount2: Operation not permitted
    umount: fbsdzpool1/ROOT/91_30062013/usr: must be superuser to umount
    umount2: Operation not permitted
    umount: fbsdzpool1/ROOT/91_30062013/usr: must be superuser to umount
    umount2: Operation not permitted
    umount: fbsdzpool1/ROOT/91_30062013/var: must be superuser to umount
    umount2: Operation not permitted
    umount: fbsdzpool1/ROOT/91_30062013/var: must be superuser to umount
    failed.
    mount: fbsdzpool1/ROOT/91_30062013: unknown device
    Will now halt.
    ifdown: shutdown usbus0: Invalid argument
    ifdown: shutdown ath0: Invalid argument
    ifdown: shutdown usbus1: Invalid argument
    ifdown: shutdown lo0: Invalid argument
    ifdown: shutdown lo0: Invalid argument
    ifdown: shutdown eth1: Invalid argument 

    deb-master: removed
```

19. Make a ZFS snapshot of the jail.
    Code:
```sh
    zfs snapshot zfs snapshot fbsdzpool1/jailz/deb-master@lenny
```
    Now, we have a base jail, from which we can generate new jails with ZFS clones, then we added a new entry to /jailz/jail.conf and we created the file /usr/local/jails/etc/fstab.newjail.
    Code:
```sh
    # zfs clone fbsdzpool1/jailz/deb-master@lenny fbsdzpool1/jailz/newjail
```
