# Boot Serial Console
```sh
#-----------------------------------------------------
# /boot/loader.conf
# Serial
sysrc -f /boot/loader.conf boot_multicons="YES"
sysrc -f /boot/loader.conf boot_serial="YES"
sysrc -f /boot/loader.conf comconsole_speed="115200"
sysrc -f /boot/loader.conf console="comconsole,vidconsole"
sysrc -f /boot/loader.conf hw.vga.textmode="1"

#-----------------------------------------------------
# Serial terminals
# /etc/ttys
ttyu0   "/usr/libexec/getty std.9600"   vt100   onifconsole secure

#-----------------------------------------------------
# /etc/inetd.conf
ssh     stream  tcp     nowait  root    /usr/sbin/sshd          sshd -i -4
#ssh    stream  tcp6    nowait  root    /usr/sbin/sshd          sshd -i -6
telnet  stream  tcp     nowait  root    /usr/libexec/telnetd    telnetd
#telnet stream  tcp6    nowait  root    /usr/libexec/telnetd    telnetd

#-----------------------------------------------------
sysrc inetd_enable="YES"
service inetd restart
```
