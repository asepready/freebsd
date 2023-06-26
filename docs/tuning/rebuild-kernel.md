```sh term
#
# Calomel.org  -|-  April 2021
#          
# https://calomel.org/freebsd_network_tuning.html
#


# Add the RACK TCP stack options to boot/loader and sysctl.conf
echo "tcp_rack_load=\"YES\"" >> /boot/loader.conf
echo "net.inet.tcp.functions_default=rack" >> /etc/sysctl.conf


# SVN Checkout the latest 12.1 source tree with current patches applied 
/usr/bin/svnlite checkout https://svn.freebsd.org/base/releng/12.1 /usr/src/


# Create a new kernel config called "CALOMEL". Add the RACK tcp stack to the GENERIC kernel.
echo -e "include GENERIC\nident   CALOMEL\nmakeoptions WITH_EXTRA_TCP_STACKS=1\noptions TCPHPTS" > /usr/src/sys/amd64/conf/CALOMEL


# Build the new kernel called "CALOMEL" and install
cd /usr/src && make buildkernel KERNCONF=CALOMEL && make installkernel KERNCONF=CALOMEL && echo SUCCESS


# If you need to free up space, remove the entire kernel source tree
cd; rm -rf /usr/src/ && mkdir /usr/src && chown root:wheel /usr/src


# Reboot the server to use the new "CALOMEL" kernel by default
reboot


# After reboot, verify the new "CALOMEL" named kernel loaded, patches
# applied (p6) and SVN revision number (r349243) similar to the following...
uname -a

  FreeBSD Rick-n-Morty 12.1-RELEASE-p0 FreeBSD 12.1-RELEASE-p6 r123456 CALOMEL amd64 
                                                                       ^^^^^^^

# Then check the available congestion control options with,
# "sysctl net.inet.tcp.functions_available". The rack TCP stack
# should have an asterisk next to it signifying RACK is the
# default TCP stack.

  net.inet.tcp.functions_available:
  Stack                           D Alias                            PCB count
  freebsd                           freebsd                          0
  rack                            * rack                             750
                                    ^^^^