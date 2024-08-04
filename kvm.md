# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/freebsd14.qcow2 \
50G
```

# 2. Menjalankan image:

```sh
virt-install --name freebsd14 \
  --virt-type kvm --memory 2048 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/freebsd14.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/FreeBSD-14.1-RELEASE-i386-disc1.iso \
  --graphics spice \
  --os-type BSD --os-variant freebsd14.0

#Compress the Image
 
