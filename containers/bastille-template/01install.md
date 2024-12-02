Installation
Bastille is available in the official FreeBSD ports tree at sysutils/bastille. Binary packages available in quarterly and latest repositories.

Current version is 0.10.20231125.

To install from the FreeBSD package repository:

quarterly repository may be older version

latest repository will match recent ports

PKG
```sh
pkg install vim git-lite bash ca_root_nss
pkg install bastille
sysrc bastille_enable=YES
sysrc bastille_rcorder=YES
```
To install from source (don’t worry, no compiling):

ports
```sh
make -C /usr/ports/sysutils/bastille install clean
sysrc bastille_enable=YES
sysrc bastille_rcorder=YES
```
network
```sh
sysrc cloned_interfaces+=lo1
sysrc ifconfig_lo1_name="bastille0"
service netif cloneup
```
GIT
```sh
git clone https://github.com/BastilleBSD/bastille.git
cd bastille
make install
sysrc bastille_enable=YES
sysrc bastille_rcorder=YES

# By default, Bastille will start all created containers at boot when enabled.
sysrc bastille_list="www"
```
This method will install the latest files from GitHub directly onto your system. It is verbose about the files it installs (for later removal), and also has a make uninstall target. You may need to manually copy the .sample config into place before Bastille will run. (ie; /usr/local/etc/bastille/bastille.conf.sample)

Note: installing using this method overwrites the version variable to match that of the source revision commit hash.

File config /usr/local/etc/bastille/bastille.conf