```sh
## loader.conf
## Disable boot menu
sysrc -f /boot/loader.conf beastie_disable="YES"
sysrc -f /boot/loader.conf autoboot_delay="-1"

## logo
splash_bmp_load="YES"
## ===============================================================================
