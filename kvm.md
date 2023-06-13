# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/freebsd13.qcow2 \
10G
```

# 2. Menjalankan image:

```sh
#  --disk path=ubuntu-vm-disk.qcow2,device=disk \
#  --disk path=user-data.img,format=raw \
#  --network default
virt-install --name freebsd13 \
  --virt-type kvm --memory 512 --vcpus 1 \
  --boot hd,menu=off \
  --disk path=/home/$USER/kvm/freebsd13.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/FreeBSD-13.2-RELEASE-i386-dvd1.iso \
  --graphics spice \
  --os-type BSD --os-variant freebsd13.0

#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/freebsd13.qcow2 -O qcow2 \
/home/$USER/kvm/fbsd13.qcow2

#run
qemu-system-x86_64 -serial mon:stdio -serial /dev/ttyS0 -nographic -hda freebsd13.qcow2