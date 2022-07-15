## Sumber Belajar
[The FreeBSD Xfce Project](https://people.freebsd.org/~olivierd/xfce-faq.html)(https://people.freebsd.org/~olivierd/xfce-faq.html)
## Pemasangan dan Konfigurasi
1. Installing the X Window System:
```sh
pkg install xorg
```
2. Configuring the X Window System:
```sh
pw groupmod video -m guestuser || pw groupmod wheel -m guestuser
```
edit /boot/loader.conf
```sh
edit /boot/loader.conf
#add /boot/loader.conf
kern.vty=vt
```
3. Setting Up and Testing the X Window System
```sh
pkg install drm-kmod
```
edit /etc/rc.conf
```sh
#/etc/rc.conf
kld_list="i915kms"
```
4. Installing and Configuring Xfce:
```sh
# install package
pkg install xfce xfce4-datetime-plugin xfce4-pulseaudio-plugin xfce4-screenshooter-plugin xfce4-whiskermenu-plugin xfce4-xkb-plugin lightdm-gtk-greeter firefox xfce-icons-elementary zenity sysctlview qt5-style-plugins slim
#config xfce
echo "exec /usr/local/bin/startxfce4 --with-ck-launch" > ~/.xinitrc
echo "exec /usr/local/bin/startxfce4 --with-ck-launch" > ~/.xsession
#enable /etc/rc.conf
lightdm_enable="YES"
moused_enable="YES"
dbus_enable="YES"
hald_enable="YES"
slim_enable="YES"

```
