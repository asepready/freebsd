[Orange Pi Zero](https://github.com/thefallenidealist/docs/blob/master/orangepi-zero-freebsd)


pkg install u-boot-orangepi-zero
doas dd if=./FreeBSD*.img of=/dev/da2 bs=1M conv=sync
dd if=/usr/local/share/u-boot/u-boot-orangepi-zero/u-boot-sunxi-with-spl.bin of=/dev/da2 bs=1024 seek=8 conv=sync
