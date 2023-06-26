# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/bsdrp.qcow2 \
2G
```

# 2. Menjalankan image:

```sh
virt-install --name freebsd13 \
  --virt-type kvm --memory 512 --vcpus 1 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/freebsd13.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/FreeBSD-13.2-RELEASE-i386-dvd1.iso \
  --graphics spice \
  --os-type BSD --os-variant freebsd13.0

#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/FreeBSD-12.4-STABLE-i386.qcow2 -O qcow2 \
/home/$USER/kvm/freebsd13.qcow2
