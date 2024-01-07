# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/freebsd14.qcow2 \
50G
```

# 2. Menjalankan image:

```sh
virt-install --name freebsd14 \
  --virt-type kvm --memory 4096 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/freebsd14.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/FreeBSD-14.0-RELEASE-amd64-disc1.iso \
  --graphics spice \
  --os-type Linux --os-variant freebsd13.1
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/freebsd14.qcow2 -O qcow2 \
/home/$USER/kvm/wazuhbsd.qcow2