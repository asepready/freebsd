# Creating a Thin Jail Using OpenZFS Snapshots
```sh
# ZFS
zfs create -o mountpoint=/usr/local/jails zroot/jails; mkdir /usr/local/jails/etc
zfs create zroot/jails/templates
zfs create -p zroot/jails/templates/13.4-RELEASE

fetch https://download.freebsd.org/ftp/releases/amd64/amd64/13.4-RELEASE/base.txz -o /usr/local/jails/media/13.4-RELEASE-base.txz

tar -xf /usr/local/jails/media/13.4-RELEASE-base.txz -C /usr/local/jails/templates/13.4-RELEASE --unlink
cp /etc/resolv.conf /usr/local/jails/templates/13.4-RELEASE/etc/resolv.conf
cp /etc/localtime /usr/local/jails/templates/13.4-RELEASE/etc/localtime
freebsd-update -b /usr/local/jails/templates/13.4-RELEASE/ fetch install

zfs snapshot zroot/jails/templates/13.4-RELEASE@base
zfs clone zroot/jails/templates/13.4-RELEASE@base zroot/jails/containers/www
```