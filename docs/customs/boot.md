# BUat splash dan boot Tanpa Menu 
1. Konfigurasi matikan boot menu
- buka dan edit untuk boot menu di /boot/loader.conf
```sh term
#Disable boot menu
sysrc -f /boot/loader.conf autoboot_delay=-1
sysrc -f /boot/loader.conf beastie_disable="YES"
sysrc -f /boot/loader.conf boot_mute="YES"
```

2.  Konfigurasi Splash
```sh file
#Stop Massegae
sysrc rc_startmsgs="NO"
sysrc syslogd_enable="NO"
sysrc -f /boot/loader.conf boot_mute="YES"
sysrc -f /boot/loader.conf beastie_disable="YES"
sysrc -f /boot/loader.conf autoboot_delay=-1

#/boot/loader.conf
kern.vty=sc
splash_bmp_load="NO"            # Set this to YES for bmp splash screen!
splash_pcx_load="NO"            # Set this to YES for pcx splash screen!
splash_txt_load="NO"            # Set this to YES for TheDraw splash screen!
vesa_load="NO"                  # Set this to YES to load the vesa module
bitmap_load="NO"                # Set this to YES if you want splash screen!
bitmap_name="splash.bmp"
```

# BUat console
```sh file
#/boot/loader.conf
boot_multicons="YES"
boot_serial="YES"
comconsole_speed="115200"
console="comconsole,vidconsole"

#/etc/ttys
#Serial console
ttyu0 "/usr/libexec/getty 3wire" vt100 onifconsole secure
ttyu1 "/usr/libexec/getty 3wire" vt100 onifconsole secure
ttyu2 "/usr/libexec/getty 3wire" vt100 onifconsole secure
ttyu3 "/usr/libexec/getty 3wire" vt100 onifconsole secure
#Dumb console
dcons "/usr/libexec/getty std.9600" vt100 off secure
```

shutdown -r now
