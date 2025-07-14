- Wayland

```sh
# or
pw groupmod video -m user

pkg install wayland seatd

# mode rootless login by users
export XDG_RUNTIME_DIR=/var/run/user/`id -u`

# For ZFS Users
mount -t tmpfs tmpfs /var/run

sysrc seatd_enable="YES"
service seatd start
```

- Wayfire Compositor

```sh
pkg install wayfire wf-shell alacritty swaylock-effects swayidle wlogout kanshi mako wlsunset

# mode rootless login by users
mkdir ~/.config/wayfire
cp /usr/local/share/examples/wayfire/wayfire.ini ~/.config/wayfire

#test
swaylock --effect-blur 7x5
```
