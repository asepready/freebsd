# BUat splash dan boot Tanpa Menu 
1. Konfigurasi matikan boot menu
- buka dan edit untuk boot menu di /boot/loader.conf
```sh term
#Disable boot menu
autoboot_delay=-1
beastie_disable="YES"
boot_mute="YES"
```

2.  Konfigurasi Splash
```sh file
#Stop Massegae
rc_startmsgs="NO"
syslogd_enable="NO"
boot_mute="YES"
beastie_disable="YES"
autoboot_delay=-1

#/boot/loader.conf
kern.vty=sc
splash_bmp_load="NO"            # Set this to YES for bmp splash screen!
splash_pcx_load="NO"            # Set this to YES for pcx splash screen!
splash_txt_load="NO"            # Set this to YES for TheDraw splash screen!
vesa_load="NO"                  # Set this to YES to load the vesa module
bitmap_load="NO"                # Set this to YES if you want splash screen!
bitmap_name="splash.bmp"
```

# Buat console
```sh file
#/boot/loader.conf
boot_multicons="YES"
boot_serial="YES"
comconsole_speed="115200"
console="comconsole,vidconsole"
hw.vga.textmode="1"

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
