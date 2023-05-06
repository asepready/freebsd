Message from isc-dhcp44-server-4.4.3P1:

--
****  To setup dhcpd, please edit /usr/local/etc/dhcpd.conf.

****  This port installs the dhcp daemon, but doesn't invoke dhcpd by default.
      If you want to invoke dhcpd at startup, add these lines to /etc/rc.conf:

            dhcpd_enable="YES"                          # dhcpd enabled?
            dhcpd_flags="-q"                            # command option(s)
            dhcpd_conf="/usr/local/etc/dhcpd.conf"      # configuration file
            dhcpd_ifaces=""                             # ethernet interface(s)
            dhcpd_withumask="022"                       # file creation mask

****  If compiled with paranoia support (the default), the following rc.conf
      options are also supported:

            dhcpd_chuser_enable="YES"           # runs w/o privileges?
            dhcpd_withuser="dhcpd"              # user name to run as
            dhcpd_withgroup="dhcpd"             # group name to run as
            dhcpd_chroot_enable="YES"           # runs chrooted?
            dhcpd_devfs_enable="YES"            # use devfs if available?
            dhcpd_rootdir="/var/db/dhcpd"       # directory to run in
            dhcpd_includedir="<some_dir>"       # directory with config-
                                                  files to include

****  WARNING: never edit the chrooted or jailed dhcpd.conf file but
      /usr/local/etc/dhcpd.conf instead which is always copied where
      needed upon startup.