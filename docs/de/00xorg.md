```sh
pkg install xorg

pw groupmod video -m username
# test run
startx

pkg install dwm

ee /usr/local/etc/X11/xinit/xinitrc