# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/freebsd13.qcow2 \
100G
```

# 2. Menjalankan image:

```sh
virt-install --virt-type=kvm \
--name=fbsd11 \
--vcpus=2 \
--memory=2048 \
--cdrom=/home/$USER/kvm/FreeBSD-13.2-RELEASE-i386-dvd1.iso \
--disk path=/home/$USER/kvm/freebsd13.qcow2,format=qcow2 \
--network default

#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/freebsd13.qcow2 -O qcow2 \
/home/$USER/kvm/freebsd13-2.qcow2

#run
qemu-system-x86_64 -serial mon:stdio -serial /dev/ttyS0 -nographic -hda freebsd13.qcow2