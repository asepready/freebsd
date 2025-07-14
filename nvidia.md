# How to get the Latest NVIDIA drivers on FreeBSD

Step-by-step instructions on installing the latest NVIDIA drivers on FreeBSD 13.0 and above.

## 1.0 Clean Up Existing Drivers

**IMPORTANT**: Log out of X session. Make sure you Desktop Manager (`sddm`|`slim`) is off. You need to be on the console.

```sh
# Create a boot env incase we need to rollback
sudo bectl create `date +%Y%m%d`-BeforeNvidia-Upgrade
sudo kldunload nvidia-modeset
sudo kldunload nvidia
sudo pkg remove -y nvidia-driver nvidia-settings nvidia-xconfig
```

## 2.0 Use Installation Script from Nvidia

Download the correct FreeBSD installation script for your GPU from NVIDIA.

```sh
cd $HOME
NVIDIA_DRIVER_VERSION="575.64.03"
fetch "https://us.download.nvidia.com/XFree86/FreeBSD-x86_64/${NVIDIA_DRIVER_VERSION}/NVIDIA-FreeBSD-x86_64-${NVIDIA_DRIVER_VERSION}.tar.xz"
tar xf NVIDIA-FreeBSD-x86_64-${NVIDIA_DRIVER_VERSION}.tar.xz
cd NVIDIA-FreeBSD-x86_64-${NVIDIA_DRIVER_VERSION}
# As per https://twitter.com/vmisev/status/1493288487931547652 -
# For 13-STABLE, move <sys/param.h> above <sys/module.h> in 'src/nvidia-modeset/nvidia-modeset-freebsd.c'
make
sudo make install
# Remove nvidia stuff from /boot/loader.conf
sudo sed -i '/nvidia/d' /boot/loader.conf
# Load nvidia modules via /etc/rc.conf
echo 'kld_list+=" nvidia-modeset nvidia "' | sudo tee /etc/rc.conf
```

At this point Nvidia drivers/libs/binaries should be installed.

```sh
# No need to reboot, just load the new drivers
sudo kldload nvidia-modeset
# Startup GUI
startx
# OR
sudo service slim|sddm start
```

## 3.0 Setup and Test Hardware Acceleration

Install necessary libraries and software

```sh
# libva, vdpau
sudo pkg install libva-utils libva-vdpau-driver vdpauinfo
# mesa
sudo pkg install mesa-demos
# vulkan
sudo pkg install vulkan-tools
```

Test using various tools.

```sh
nvidia-smi
glinfo
glxinfo
vainfo
vdpauinfo
vulkaninfo
```

## 4.0 Linuxlator

We are going to use the [linux-browser-installer](https://github.com/mrclksr/linux-browser-installer) script to setup a Ubuntu image for the Linuxulator instead of the CentOS-7 based linux-c7 packages.

### 4.1 Setup Ubuntu

```sh
cd $HOME
git clone --depth=1 https://github.com/mrclksr/linux-browser-installer
cd linux-browser-installer
# First create the chroot
sudo ./linux-browser-installer chroot create
# chroot into ubuntu
sudo chroot /compat/ubuntu /bin/bash
# Configure additional repositories to install updates, backports, security patches.
cat <<END >> /etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu/ focal-updates  main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-backports  main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-security  main restricted universe multiverse
END
apt update && apt -y upgrade
# exit from the chroot
exit
sudo ./linux-browser-installer install chrome # OR vivaldi|brave|edge
sudo ./linux-browser-installer  symlink icons
sudo ./linux-browser-installer  symlink themes
```

At this point you should have a functional Ubuntu based Linuulator. You will need to reboot at this point so that FreeBSD switches from `/compat/linux` to `/compat/ubuntu`.

### 4.2 Setup Nvidia Drivers in Linuxulator

We are going to setup both 64-bit and, 32-bit libraries under Linuxulator. That way even 32-bit based programs (e.g. steam) can access `OpenGL`, `vulkan` APIs.

```sh
sudo chroot /compat/ubuntu /bin/bash
# ------ Everything below in to be executed in the chroot -------


# First setup 32-bit support
dpkg --add-architecture i386
apt update && sudo apt -y upgrade

# Next install NVIDIA drivers using the installation script
cd $HOME
mkdir -p $HOME/TMP && rm -rf $HOME/TMP/*

NVIDIA_DRIVER_VERSION="510.54"
wget -q "https://us.download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_DRIVER_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run"
chmod +x NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run

# Install the NVIDIA libraries, binaries, and drivers but skip the kernel modules.
TMPDIR=$HOME/TMP ./NVIDIA-Linux-x86_64-510.54.run \
    --accept-license --skip-module-unload --silent \
    --install-compat32-libs \
    --no-nvidia-modprobe --no-backup --no-kernel-module \
    --no-x-check --no-nouveau-check \
    --no-cc-version-check --no-kernel-module-source \
    --no-check-for-alternate-installs \
    --no-unified-memory --no-drm --no-peermem \
    --install-libglvnd --skip-depmod --no-systemd

# Next install some 64-bit, and 32-bit libraries and tools
apt-get install -y vainfo vdpauinfo vulkan-tools mesa-utils
apt install -y libva2:i386 libvulkan1:i386 libvdpau1:i386

# Lastly we need to download vdpau-va-driver manually from a previous version of Ubuntu because it was removed from Ubuntu 20.x.
# We need this for the vdpau backend for libva
apt-get install -y gdebi
wget -q 'http://archive.ubuntu.com/ubuntu/pool/universe/v/vdpau-video/vdpau-va-driver_0.7.4-6ubuntu1_amd64.deb'
gdebi vdpau-va-driver_0.7.4-6ubuntu1_amd64.deb

wget -q 'http://archive.ubuntu.com/ubuntu/pool/universe/v/vdpau-video/vdpau-va-driver_0.7.4-6ubuntu1_i386.deb'
gdebi vdpau-va-driver_0.7.4-6ubuntu1_i386.deb

# Exit out of chroot
exit
```

### 4.3 Test Hardware Acceleration from Linuxulator

First test 64-bit from your normal FreeBSD user account (not root and not inside chroot) inside an X session.

```sh
/compat/ubuntu/usr/bin/nvidia-smi
/compat/ubuntu/usr/bin/glxinfo
/compat/ubuntu/usr/bin/vdpauinfo
/compat/ubuntu/usr/bin/vainfo
/compat/ubuntu/usr/bin/vulkaninfo
```

Next test 32-bit

```sh
sudo pkg install -y libc6-shim
with-glibc-shim /libexec/ld-elf.so.1 /compat/ubuntu/usr/bin/nvidia-smi
with-glibc-shim /libexec/ld-elf.so.1 /compat/ubuntu/usr/bin/glxinfo
with-glibc-shim /libexec/ld-elf.so.1 /compat/ubuntu/usr/bin/vdpauinfo
with-glibc-shim /libexec/ld-elf.so.1 /compat/ubuntu/usr/bin/vainfo
with-glibc-shim /libexec/ld-elf.so.1 /compat/ubuntu/usr/bin/vulkaninfo
```

### 4.4 Enable Hardware acceleration in Linuxulator Browsers

To enable the Linuxlator browsers like chrome, brave, vivaldi, edge to use hardware acceleration add the following flags to their respective startup scripts in `/compat/ubuntu/bin/<chrome|brave|vivaldi|edge>`

I have shown my `/compat/ubuntu/bin/chrome` file below

```sh
#!/compat/ubuntu/bin/bash
#
# chrome wrapper script from patovm04:
# https://forums.freebsd.org/threads/linuxulator-how-to-run-google-chrome-linux-binary-on-freebsd.77559/
#
export CHROME_PATH="/opt/google/chrome/chrome"
export CHROME_WRAPPER="$(readlink -f "$0")"
export LD_LIBRARY_PATH=/usr/local/steam-utils/lib64/fakeudev
export LD_PRELOAD=/usr/local/steam-utils/lib64/webfix/webfix.so
#export LIBGL_DRI3_DISABLE=1
exec -a "$0" "$CHROME_PATH" \
	--password-store=basic  \
	--use-gl=desktop \
	--use-cmd-decoder=validating \
	--disable-software-rasterizer \
	--disable-font-subpixel-positioning \
	--disable-gpu-driver-bug-workarounds \
	--disable-gpu-driver-workarounds \
	--disable-gpu-vsync \
	--enable-accelerated-video-decode \
	--enable-accelerated-mjpeg-decode \
	--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,CanvasOopRasterization \
	--enable-gpu-compositing \
	--enable-gpu-rasterization \
	--enable-native-gpu-memory-buffers \
	--enable-oop-rasterization \
	--canvas-oop-rasterization \
	--enable-raw-draw \
	--use-vulkan \
	--enable-zero-copy \
	--ignore-gpu-blocklist \
	--check-for-update-interval=604800 \
	--no-sandbox --no-zygote --test-type --v=0 "$@"

```

Launch Chrome and verify hardware-acceleration by checking `chrome://gpu`.
