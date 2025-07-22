Podman : Install

Install Podman that is the Container management tool.
Podman on FreeBSD is still an experimental feature and should not be used in production.

[1] Install Podman.

```sh
root@dlp:~ # pkg install -y podman
```

[2] Configure required settings.

```sh
# mount fdescfs
root@dlp:~ # mount -t fdescfs fdesc /dev/fd
root@dlp:~ # vi /etc/fstab
# add the line
# Device                Mountpoint      FStype  Options         Dump    Pass#
/dev/gpt/efiboot0       /boot/efi       msdosfs rw              2       2
/dev/vtbd0p3            none    swap    sw              0       0
fdesc                   /dev/fd         fdescfs rw      0       0

root@dlp:~ # ifconfig
vtnet0: flags=1008843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST,LOWER_UP> metric 0 mtu 1500
        options=4c07bb<RXCSUM,TXCSUM,VLAN_MTU,VLAN_HWTAGGING,JUMBO_MTU,VLAN_HWCSUM,TSO4,TSO6,LRO,VLAN_HWTSO,LINKSTATE,TXCSUM_IPV6>
        ether 52:54:00:6c:78:51
        inet 10.0.0.30 netmask 0xffffff00 broadcast 10.0.0.255
        inet6 fe80::5054:ff:fe6c:7851%vtnet0 prefixlen 64 scopeid 0x1
        media: Ethernet autoselect (10Gbase-T <full-duplex>)
        status: active
        nd6 options=23<PERFORMNUD,ACCEPT_RTADV,AUTO_LINKLOCAL>
lo0: flags=1008049<UP,LOOPBACK,RUNNING,MULTICAST,LOWER_UP> metric 0 mtu 16384
        options=680003<RXCSUM,TXCSUM,LINKSTATE,RXCSUM_IPV6,TXCSUM_IPV6>
        inet 127.0.0.1 netmask 0xff000000
        inet6 ::1 prefixlen 128
        inet6 fe80::1%lo0 prefixlen 64 scopeid 0x2
        groups: lo
        nd6 options=21<PERFORMNUD,AUTO_LINKLOCAL>

root@dlp:~ # ifconfig vtnet0 -rxcsum -txcsum -rxcsum6 -txcsum6 -tso -lro
root@dlp:~ # echo "ifconfig vtnet0 -rxcsum -txcsum -rxcsum6 -txcsum6 -tso -lro" >> /etc/rc.conf
root@dlp:~ # cp /usr/local/etc/containers/pf.conf.sample /etc/pf.conf
root@dlp:~ # vi /etc/pf.conf
# change to your interface name
v4egress_if = "vtnet0"
v6egress_if = "vtnet0"

root@dlp:~ # service pf enable
pf enabled in /etc/rc.conf
root@dlp:~ # service pf start
Enabling pf.
# if your system is not configured with ZFS, change setting below
root@dlp:~ # vi /usr/local/etc/containers/storage.conf
# line 17 : change to vfs
driver = "vfs"

# verify podman command
root@dlp:~ # podman images
REPOSITORY               TAG      IMAGE ID       CREATED          SIZE
```
