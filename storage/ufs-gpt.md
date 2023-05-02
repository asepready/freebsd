<p align="center">
<img src="./assets/images/logo.png" alt="Logo" style="width:200px;"/>
</p>

https://www.vultr.com/docs/how-to-resize-a-disk-in-freebsd/

### Catatan hasil belajar FreeBSD support versi =>11.*
## How to Resize a Disk in FreeBSD
The FreeBSD operating system utilizes UFS (Unix File System) for its root partition's file system; otherwise known as `freebsd-ufs`

In the event of an upgraded disk size, we will illustrate how to expand this file system.
### Prerequisites
-----------------------------------------------------------------------
1) To follow this tutorial, deploy one of the following: FreeBSD 11 x64

    We utilized the following plan to begin our deployment:
    | Komponen | Deskripsi |
    |--|--|
    | CPU | 1 vCore |
    | RAM | 512 MB |
    | Storage | 2 GB |

2) Prior to upgrading your intance, confirm its current disk allocation & partition table: 
    ```sh term
        data@FBSD12:~ $ df -h
        Filesystem    Size    Used   Avail Capacity  Mounted on
        /dev/da0p3    1.8G    1.4G    279M    84%    /
        devfs         1.0K    1.0K      0B   100%    /dev

        data@FBSD12:~ $ gpart show
        =>      40    4194224  da0  GPT  (2.0G)
                40      1024    1  freebsd-boot  (512K)
              1064    208896    2  freebsd-swap  (102M)
            209960   3984304    3  freebsd-ufs  (1.9G)
    ```

3) Upgrade your instance's plan:
    - Visit your Vultr management page
    - Select the instance that you'd like to upgrade.
    - Choose the "Settings" link near the top of the page.
    - Click the "Change Plan" link on the Side to show a dropdown menu of available upgrade choices.

    In this case, we upgraded our plan to the following:
    | Komponen | Deskripsi |
    |--|--|
    | CPU | 4 vCore |
    | RAM | 2048 MB |
    | Storage | 10 GB |
-----------------------------------------------------------------------
### 1. Confirm New Disk Space
Although the disk allocation appears the same at first, gpart illustrates a change::
```sh term
    root@lab-FBSD:~ # df -h
    Filesystem    Size    Used   Avail Capacity  Mounted on
    /dev/da0p3    1.8G    1.4G    279M    84%    /
    devfs         1.0K    1.0K      0B   100%    /dev

    root@lab-FBSD:~ # gpart show 
    =>      40  20971447  da0  GPT  (10G)[CORRUPT]
            40      1024    1  freebsd-boot  (512K)
          1064    208896    2  freebsd-swap  (102M)
        209960   3984304    3  freebsd-ufs  (1.9G)
```
### 2. Recover the Corrupt Partition
```sh term
    root@lab-FBSD:~ # gpart recover da0
    da0 recovered

    root@lab-FBSD:~ # gpart show 
    =>      40  20971447  da0  GPT  (10G)[CORRUPT]
            40      1024    1  freebsd-boot  (512K)
          1064    208896    2  freebsd-swap  (102M)
        209960   3984304    3  freebsd-ufs  (1.9G)
       4194264  16777223       - free -  (8.0G)
```
### 3. Resize the freebsd-ufs Partition
WARNING!!!
`
There is risk of data loss when modifying the partition table of a mounted file system. It is best to perform the following steps on an unmounted file system while running from a live CD-ROM or USB device.`
Since this is a recently deployed instance, there is no sensitive data to backup; however, in the event of upgrading an instance currently in production, its best practice to perform an offsite backup prior to making any changes to the partition table.

Once you're ready to proceed, do the following:
```sh term
root@FBSD12:/home/data # gpart resize -i 3 da0
da0p3 resized

root@lab-FBSD:~ # gpart show
=>       0  20971520  da0  BSD  (10G)
         0   3983360    1  freebsd-ufs  (1.9G)
   3983360    208896    2  freebsd-swap  (8.1G)
```
### 4. Grow the UFS File System
In order to expand the freebsd-ufs or /dev/da0p3 paritition, start the growfs service:
```sh term
root@FBSD12:/home/data # service growfs onestart
```
Alternatively, you can run the following command.
```sh term
growfs  /dev/da0p3
```
### 5. Confirm the Changes
```sh term
root@FBSD12:/home/data # df -h
Filesystem    Size    Used   Avail Capacity  Mounted on
/dev/da0p3    9.6G    1.4G    7.4G    16%    /
devfs         1.0K    1.0K      0B   100%    /dev

root@FBSD12:/home/data # gpart show
=>      40  20971447  da0  GPT  (10G)
        40      1024    1  freebsd-boot  (512K)
      1064    208896    2  freebsd-swap  (102M)
    209960  20761527    3  freebsd-ufs  (9.9G)
```