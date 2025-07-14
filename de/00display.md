# Display Server

sistem tampilan (display server) yang digunakan dalam sistem operasi berbasis Unix/Linux untuk mengelola antarmuka grafis pengguna (GUI):

- Xorg

```sh
pw groupmod video -m root,$USER

pkg install xorg # old
# test run
startx

pkg install dwm

ee /usr/local/etc/X11/xinit/xinitrc
```
