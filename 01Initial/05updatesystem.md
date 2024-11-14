Initial Settings : Update System2023/12/14
 	
After it has been a production System, maybe it's difficult to update System, but at least after installing, Update FreeBSD Server to the latest.
[1]	To update installed packages to the latest version, do like follows.
```sh
# update repository catalogue
root@hosts:~# pkg update
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.

# update all packages in the system
root@hosts:~# pkg upgrade -y
The package management tool is not yet installed on your system.
Do you want to fetch and install it now? [y/N]: y
Bootstrapping pkg from pkg+http://pkg.FreeBSD.org/FreeBSD:14:amd64/quarterly, please wait...
Verifying signature with trusted certificate pkg.freebsd.org.2013102301... done
Installing pkg-1.20.8...
Extracting pkg-1.20.8: 100%
Updating FreeBSD repository catalogue...
Fetching meta.conf: 100%    163 B   0.2kB/s    00:01
Fetching packagesite.pkg: 100%    7 MiB 551.3kB/s    00:13
Processing entries: 100%
FreeBSD repository update completed. 33875 packages processed.
All repositories are up to date.
Updating database digests format: 100%
Checking for upgrades (1 candidates): 100%
Processing candidates (1 candidates): 100%
Checking integrity... done (0 conflicting)
Your packages are up to date.
[2]	To update the base system including the kernel to the latest version, do like follows.
# current version
root@hosts:~# freebsd-version
14.0-RELEASE
# download the latest patches
root@hosts:~# freebsd-update fetch
src component not installed, skipped
Looking up update.FreeBSD.org mirrors... 3 mirrors found.
Fetching public key from update2.freebsd.org... done.
Fetching metadata signature for 14.0-RELEASE from update2.freebsd.org... done.
Fetching metadata index... done.
Fetching 2 metadata files... done.
Inspecting system... done.
Preparing to download files... done.
Fetching 255 patches.....10....20....30....40....50....60....70....80....90....100....110....120....130....140....150....160....170....180....190....200....210....220....230....240....250.. done.
Applying patches... done.
The following files will be updated as part of updating to
14.0-RELEASE-p8:
/bin/df
/bin/freebsd-version
/bin/mv

.....
.....

# finally, downloaded files are passed to a pager-type command and displayed
# to check them, scroll down with the space bar or cursor keys
# to quit, press [q] key

# apply the downloaded patches
root@hosts:~# freebsd-update install
src component not installed, skipped
Creating snapshot of existing boot environment... done.
Installing updates...
Restarting sshd after upgrade
Performing sanity check on sshd configuration.
Stopping sshd.
Waiting for PIDS: 860, 860.
Performing sanity check on sshd configuration.
Starting sshd.
Scanning /usr/share/certs/untrusted for certificates...
Scanning /usr/share/certs/trusted for certificates...
 done.

# if the kernel is updated, reboot is required
root@hosts:~# reboot
root@hosts:~# freebsd-version
14.0-RELEASE-p8
[3]	To update your system to the latest minor version, do like follows.
# current version
root@hosts:~# freebsd-version
14.0-RELEASE-p8
# upgrade to FreeBSD 14.1
root@hosts:~# freebsd-update upgrade -r 14.1-RELEASE
src component not installed, skipped
Looking up update.FreeBSD.org mirrors... 3 mirrors found.
Fetching metadata signature for 14.0-RELEASE from update1.freebsd.org... done.
Fetching metadata index... done.
Fetching 1 metadata files... done.
Inspecting system... done.

The following components of FreeBSD seem to be installed:
kernel/generic kernel/generic-dbg world/base world/lib32

The following components of FreeBSD do not seem to be installed:
world/base-dbg world/lib32-dbg

Does this look reasonable (y/n)? y

etching metadata signature for 14.1-RELEASE from update1.freebsd.org... done.
Fetching metadata index... done.
Fetching 1 metadata patches. done.
Applying metadata patches... done.
Fetching 1 metadata files... done.
Inspecting system... done.

.....
.....

The following files will be removed as part of updating to
14.1-RELEASE-p2:
/etc/ssl/certs/f3377b1b.0
/usr/include/c++/v1/__bsd_locale_defaults.h
/usr/include/c++/v1/__bsd_locale_fallbacks.h
/usr/include/c++/v1/__debug
/usr/include/c++/v1/__errc
/usr/include/c++/v1/__functional/unwrap_ref.h
/usr/include/c++/v1/__mutex_base

.....
.....

# finally, downloaded files are passed to a pager-type command and displayed
# to check them, scroll down with the space bar or cursor keys
# to quit, press [q] key

# apply the downloaded patches
root@hosts:~# freebsd-update install
src component not installed, skipped
Creating snapshot of existing boot environment... done.
Installing updates...
Kernel updates have been installed.  Please reboot and run
"/usr/sbin/freebsd-update install" again to finish installing updates.

# After upgrading, reboot the computer and
# run [freebsd-update] again as instructed in the message
root@hosts:~# reboot
root@hosts:~# freebsd-update install
src component not installed, skipped
Creating snapshot of existing boot environment... done.
Installing updates...
Restarting sshd after upgrade
Performing sanity check on sshd configuration.
Stopping sshd.
Waiting for PIDS: 876.
Performing sanity check on sshd configuration.
Starting sshd.
Scanning /usr/share/certs/untrusted for certificates...
Scanning /usr/share/certs/trusted for certificates...
 done.

root@hosts:~# freebsd-version
14.1-RELEASE-p2