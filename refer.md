https://www.zenarmor.com/docs/freebsd-tutorials/how-to-configure-linux-binary-compatibility-on-freebsd
https://productionwithscissors.run/2022/09/04/containerd-linux-on-freebsd/
https://samuel.karp.dev/blog/2021/05/running-freebsd-jails-with-containerd-1-5/
https://github.com/thefallenidealist/docs/blob/master/orangepi-zero-freebsd



pkg install u-boot-orangepi-zero
doas dd if=./FreeBSD*.img of=/dev/da2 bs=1M conv=sync
dd if=/usr/local/share/u-boot/u-boot-orangepi-zero/u-boot-sunxi-with-spl.bin of=/dev/da2 bs=1024 seek=8 conv=sync
