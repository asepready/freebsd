```sh
#
# Calomel.org  -|-  April 2021
#
# https://calomel.org/freebsd_network_tuning.html
#

# TCP Tuning: The throughput of connection is limited by two windows: the
# (Initial) Congestion Window and the TCP Receive Window (RWIN). The Congestion
# Window avoids exceeding the capacity of the network (RACK, CAIA, H-TCP or
# NewReno congestion control); and the Receive Window avoids exceeding the
# capacity of the receiver to process data (flow control). When our server is
# able to process packets as fast as they are received we want to allow the
# remote sending host to send data as fast as the network, Congestion Window,
# will allow. https://en.wikipedia.org/wiki/TCP_tuning

# IPC Socket Buffer: the maximum combined socket buffer size, in bytes, defined
# by SO_SNDBUF and SO_RCVBUF. kern.ipc.maxsockbuf is also used to define the
# window scaling factor (wscale in tcpdump) our server will advertise. The
# window scaling factor is defined as the maximum volume of data allowed in
# transit before the recieving server is required to send an ACK packet
# (acknowledgment) to the sending server. FreeBSD's default maxsockbuf value is
# two(2) megabytes which corresponds to a window scaling factor (wscale) of
# six(6) allowing the remote sender to transmit up to 2^6 x 65,535 bytes =
# 4,194,240 bytes (4MB) in flight, on the network before requiring an ACK
# packet from our server. In order to support the throughput of modern, long
# fat networks (LFN) with variable latency we suggest increasing the maximum
# socket buffer to at least 16MB if the system has enough RAM. "netstat -m"
# displays the amount of network buffers used. Increase kern.ipc.maxsockbuf if
# the counters for "mbufs denied" or "mbufs delayed" are greater than zero(0).
# https://en.wikipedia.org/wiki/TCP_window_scale_option
# https://en.wikipedia.org/wiki/Bandwidth-delay_product
#
# speed:   1 Gbit   maxsockbuf:   2MB   wscale:  6   in-flight:  2^6*65KB =    4MB (default)
# speed:   2 Gbit   maxsockbuf:   4MB   wscale:  7   in-flight:  2^7*65KB =    8MB
# speed:  10 Gbit   maxsockbuf:  16MB   wscale:  9   in-flight:  2^9*65KB =   32MB
# speed:  40 Gbit   maxsockbuf: 150MB   wscale: 12   in-flight: 2^12*65KB =  260MB
# speed: 100 Gbit   maxsockbuf: 600MB   wscale: 14   in-flight: 2^14*65KB = 1064MB
#
#kern.ipc.maxsockbuf=2097152    # (wscale  6 ; default)
#kern.ipc.maxsockbuf=4194304    # (wscale  7)
kern.ipc.maxsockbuf=16777216   # (wscale  9)
#kern.ipc.maxsockbuf=157286400  # (wscale 12)
#kern.ipc.maxsockbuf=614400000   # (wscale 14)

# TCP Buffers: Larger buffers and TCP Large Window Extensions (RFC1323) can
# help alleviate the long fat network (LFN) problem caused by insufficient
# window size; limited to 65535 bytes without RFC 1323 scaling. Verify the
# window scaling extension is enabled with net.inet.tcp.rfc1323=1, which is
# default. Both the client and server must support RFC 1323 to take advantage
# of scalable buffers. A network connection at 100Mbit/sec with a latency of 10
# milliseconds has a bandwidth-delay product of 125 kilobytes
# ((100*10^6*10*10^-3)/8=125000) which is the same BDP of a 1Gbit LAN with
# one(1) millisecond latency ((1000*10^6*1*10^-3)/8=125000 bytes). As the
# latency and/or throughput increase so does the BDP. If the connection needs
# more buffer space the kernel will dynamically increase these network buffer
# values by net.inet.tcp.sendbuf_inc and net.inet.tcp.recvbuf_inc increments.
# Use "netstat -an" to watch Recv-Q and Send-Q as the kernel increases the
# network buffer up to net.inet.tcp.recvbuf_max and net.inet.tcp.sendbuf_max .
# https://en.wikipedia.org/wiki/Bandwidth-delay_product
#
#net.inet.tcp.recvbuf_inc=65536   # (default 16384)
net.inet.tcp.recvbuf_max=4194304  # (default 2097152)
net.inet.tcp.recvspace=65536      # (default 65536)
net.inet.tcp.sendbuf_inc=65536    # (default 8192)
net.inet.tcp.sendbuf_max=4194304  # (default 2097152)
net.inet.tcp.sendspace=65536      # (default 32768)

# maximum segment size (MSS) specifies the largest payload of data in a single
# IPv4 TCP segment. RFC 6691 states the maximum segment size should equal the
# effective MTU minus the fixed IP and TCP headers, but before subtracting IP
# options like TCP timestamps. Path MTU Discovery (PMTUD) is not supported by
# all internet paths and can lead to increased connection setup latency so the
# MMS can be defined manually.
#
# Option 1 - Maximum Payload - To construct the maximum MMS, start with an
# ethernet frame size of 1514 bytes and subtract 14 bytes for the ethernet
# header for an interface MTU of 1500 bytes. Then subtract 20 bytes for the IP
# header and 20 bytes for the TCP header to equal an Maximum Segment Size (MSS)
# of tcp.mssdflt=1460 bytes. With net.inet.tcp.rfc1323 enabled the packet
# payload is reduced by a further 12 bytes and the MSS is reduced from
# tcp.mssdflt=1460 bytes to a packet payload of 1448 bytes total. An MMS of
# 1448 bytes has a 95.64% packet efficiency (1448/1514=0.9564).
#
# Option 2 - No Frags - Google states the HTTP/3 QUIC (Quick UDP Internet
# Connection) IPv4 datagram should be no larger than 1280 octets to attempt to
# avoid any packet fragmentation over any Internet path. To follow Google's
# no-fragment UDP policy for TCP packets set FreeBSD's MSS to 1240 bytes. To
# construct Google's no-fragment datagram start with an ethernet frame size of
# 1294 bytes and subtract 14 bytes for the ethernet header to equal Google's
# recommended PMTU size of 1280 bytes. Then subtract 20 bytes for the IP header
# and 20 bytes for the TCP header to equal tcp.mssdflt=1240 bytes. Then, before
# the packet is sent, FreeBSD will set the TCP timestamp (rfc1323) on the
# packet reducing the true packet payload (MSS) another 12 bytes from
# tcp.mssdflt=1240 bytes to 1228 bytes which has an 94.89% packet efficiency
# (1228/1294=0.9489). https://tools.ietf.org/html/draft-ietf-quic-transport-20
#
# Broken packets: IP fragmentation is flawed
# https://blog.cloudflare.com/ip-fragmentation-is-broken/
#
# FYI: PF with an outgoing scrub rule will re-package the packet using an MTU
# of 1460 by default, thus overriding the mssdflt setting wasting CPU time and
# adding latency.
#
net.inet.tcp.mssdflt=1460   # Option 1 (default 536)
#net.inet.tcp.mssdflt=1240  # Option 2 (default 536)

# minimum, maximum segment size (mMSS) specifies the smallest payload of data
# in a single IPv4 TCP segment our system will agree to send when negotiating
# with the client. RFC 6691 states that a minimum MTU size of 576 bytes must be
# supported and the MSS option should equal the effective MTU minus the fixed
# IP and TCP headers, but without subtracting IP or TCP options. To construct
# the minimum MSS start with a frame size of 590 bytes and subtract 14 bytes
# for the ethernet header to equal the RFC 6691 recomended MTU size of 576
# bytes. Continue by subtracting 20 bytes for the IP header and 20 bytes for
# the TCP header to equal tcp.minmss=536 bytes. Then, before the packet is
# sent, FreeBSD will set the TCP timestamp (rfc1323) on the packet reducing the
# true packet payload (MSS) another 12 bytes from tcp.minmss=536 bytes to 524
# bytes which is 90.9% packet efficiency (524/576=0.909). The default mMMS is
# only 84% efficient (216/256=0.84).
#
net.inet.tcp.minmss=536  # (default 216)

# TCP Slow start gradually increases the data send rate until the TCP
# congestion algorithm (CDG, H-TCP) calculates the networks maximum carrying
# capacity without dropping packets. TCP Congestion Control with Appropriate
# Byte Counting (ABC) allows our server to increase the maximum congestion
# window exponentially by the amount of data ACKed, but limits the maximum
# increment per ACK to (abc_l_var * maxseg) bytes. An abc_l_var of 44 times a
# maxseg of 1460 bytes would allow slow start to increase the congestion window
# by more than 64 kilobytes per step; 65535 bytes is the TCP receive buffer
# size of most hosts without TCP window scaling.
#
net.inet.tcp.abc_l_var=44   # (default 2) if net.inet.tcp.mssdflt = 1460
#net.inet.tcp.abc_l_var=52  # (default 2) if net.inet.tcp.mssdflt = 1240

# Initial Congestion Window (initcwnd) limits the amount of segments TCP can
# send onto the network before receiving an ACK from the other machine.
# Increasing the TCP Initial Congestion Window will reduce data transfer
# latency during the slow start phase of a TCP connection. The initial
# congestion window should be increased to speed up short, burst connections in
# order to send the most data in the shortest time frame without overloading
# any network buffers. Google's study reported sixteen(16) segments as showing
# the lowest latency initial congestion window. Also test 44 segments which is
# 65535 bytes, the TCP receive buffer size of most hosts without TCP window
# scaling.
# https://developers.google.com/speed/pagespeed/service/tcp_initcwnd_paper.pdf
#
net.inet.tcp.initcwnd_segments=44            # (default 10 for FreeBSD 11.2) if net.inet.tcp.mssdflt = 1460
#net.inet.tcp.initcwnd_segments=52           # (default 10 for FreeBSD 11.2) if net.inet.tcp.mssdflt = 1240
#net.inet.tcp.experimental.initcwnd10=1      # (default  1 for FreeBSD 10.1)
#net.inet.tcp.experimental.initcwnd10=1      # (default  0 for FreeBSD  9.2)
#net.inet.tcp.local_slowstart_flightsize=16  # (default  4 for FreeBSD  9.1)
#net.inet.tcp.slowstart_flightsize=16        # (default  4 for FreeBSD  9.1)

# RFC 8511 TCP Alternative Backoff with ECN (ABE) for FreeBSD's default
# congestion control mechanism, NewReno. The reception of a Congestion
# Experienced (CE) Explicit Congestion Notification (ECN) event indicates that
# an Active Queue Management (AQM) mechanism is used at the bottleneck, thus an
# assumption can be made that the bottleneck network queue is transient. The
# feedback of this signal allows the TCP sender-side ECN reaction in congestion
# avoidance to reduce the Congestion Window (cwnd) by a less aggressive 20%
# rather than the NewReno default of 50% when inferred packet loss is detected.
# The goal is more packets on the wire using greater network capacity while
# minimizing actual packet loss. https://tools.ietf.org/html/rfc8511
#
net.inet.tcp.cc.abe=1  # (default 0, disabled)

# RFC 6675 increases the accuracy of TCP Fast Recovery when combined with
# Selective Acknowledgement (net.inet.tcp.sack.enable=1). TCP loss recovery is
# enhanced by computing "pipe", a sender side estimation of the number of bytes
# still outstanding on the network. Fast Recovery is augmented by sending data
# on each ACK as necessary to prevent "pipe" from falling below the slow-start
# threshold (ssthresh). The TCP window size and SACK-based decisions are still
# determined by the congestion control algorithm; CDG, CUBIC or H-TCP if
# enabled, newreno by default.
#
net.inet.tcp.rfc6675_pipe=1  # (default 0)

# Reduce the amount of SYN/ACKs the server will re-transmit to an ip address
# whom did not respond to the first SYN/ACK. On a client's initial connection
# our server will always send a SYN/ACK in response to the client's initial
# SYN. Limiting retranstited SYN/ACKS reduces local syn cache size and a "SYN
# flood" DoS attack's collateral damage by not sending SYN/ACKs back to spoofed
# ips, multiple times. If we do continue to send SYN/ACKs to spoofed IPs they
# may send RST's back to us and an "amplification" attack would begin against
# our host. If you do not wish to send retransmits at all then set to zero(0)
# especially if you are under a SYN attack. If our first SYN/ACK gets dropped
# the client will re-send another SYN if they still want to connect. Also set
# "net.inet.tcp.msl" to two(2) times the average round trip time of a client,
# but no lower then 2000ms (2s). Test with "netstat -s -p tcp" and look under
# syncache entries. http://www.ouah.org/spank.txt
# https://people.freebsd.org/~jlemon/papers/syncache.pdf
#
net.inet.tcp.syncache.rexmtlimit=0  # (default 3)

# IP fragments require CPU processing time and system memory to reassemble. Due
# to multiple attacks vectors ip fragmentation can contribute to and that
# fragmentation can be used to evade packet inspection and auditing, we will
# not accept IPv4 or IPv6 fragments. Comment out these directives when
# supporting traffic which generates fragments by design; like NFS and certain
# preternatural functions of the Sony PS4 gaming console.
# https://en.wikipedia.org/wiki/IP_fragmentation_attack
# https://www.freebsd.org/security/advisories/FreeBSD-SA-18:10.ip.asc
#
net.inet.ip.maxfragpackets=0     # (default 63474)
net.inet.ip.maxfragsperpacket=0  # (default 16)
net.inet6.ip6.maxfragpackets=0   # (default 507715)
net.inet6.ip6.maxfrags=0         # (default 507715)

# Syncookies have advantages and disadvantages. Syncookies are useful if you
# are being DoS attacked as this method helps filter the proper clients from
# the attack machines. But, since the TCP options from the initial SYN are not
# saved in syncookies, the tcp options are not applied to the connection,
# precluding use of features like window scale, timestamps, or exact MSS
# sizing. As the returning ACK establishes the connection, it may be possible
# for an attacker to ACK flood a machine in an attempt to create a connection.
# Another benefit to overflowing to the point of getting a valid SYN cookie is
# the attacker can include data payload. Now that the attacker can send data to
# a FreeBSD network daemon, even using a spoofed source IP address, they can
# have FreeBSD do processing on the data which is not something the attacker
# could do without having SYN cookies. Even though syncookies are helpful
# during a DoS, we are going to disable syncookies at this time.
#
net.inet.tcp.syncookies=0  # (default 1)

# RFC 6528 Initial Sequence Numbers (ISN) refer to the unique 32-bit sequence
# number assigned to each new Transmission Control Protocol (TCP) connection.
# The TCP protocol assigns an ISN to each new byte, beginning with 0 and
# incrementally adding a secret number every four seconds until the limit is
# exhausted. In continuous communication all available ISN options could be
# used up in a few hours. Normally a new secret number is only chosen after the
# ISN limit has been exceeded. In order to defend against Sequence Number
# Attacks the ISN secret key should not be used sufficiently often that it
# would be regarded as predictable, and thus insecure. Reseeding the ISN will
# break TIME_WAIT recycling for a few minutes. BUT, for the more paranoid,
# simply choose a random number of seconds in which a new ISN secret should be
# generated.  https://tools.ietf.org/html/rfc6528
#
net.inet.tcp.isn_reseed_interval=4500  # (default 0, disabled)

# TCP segmentation offload (TSO), also called large segment offload (LSO),
# should be disabled on NAT firewalls and routers. TSO/LSO works by queuing up
# large 64KB buffers and letting the network interface card (NIC) split them
# into separate packets. The problem is the NIC can build a packet that is the
# wrong size and would be dropped by a switch or the receiving machine, like
# for NFS fragmented traffic. If the packet is dropped the overall sending
# bandwidth is reduced significantly. You can also disable TSO in /etc/rc.conf
# using the "-tso" directive after the network card configuration; for example,
# ifconfig_igb0="inet 10.10.10.1 netmask 255.255.255.0 -tso". Verify TSO is off
# on the hardware by making sure TSO4 and TSO6 are not seen in the "options="
# section using ifconfig.
# http://www.peerwisdom.org/2013/04/03/large-send-offload-and-network-performance/
#
net.inet.tcp.tso=0  # (default 1)

# Intel i350-T2 igb(4): flow control manages the rate of data transmission
# between two nodes preventing a fast sender from overwhelming a slow receiver.
# Ethernet "PAUSE" frames will pause transmission of all traffic types on a
# physical link, not just the individual flow causing the problem. By disabling
# physical link flow control the link instead relies on native TCP or QUIC UDP
# internal congestion control which is peer based on IP address and more fair
# to each flow. The options are: (0=No Flow Control) (1=Receive Pause)
# (2=Transmit Pause) (3=Full Flow Control, Default). A value of zero(0)
# disables ethernet flow control on the Intel igb(4) interface.
# http://virtualthreads.blogspot.com/2006/02/beware-ethernet-flow-control.html
#
dev.igb.0.fc=0  # (default 3)

# Intel i350-T2 igb(4): the rx_budget sets the maximum number of receive
# packets to process in an interrupt. If the budget is reached, the
# remaining/pending packets will be processed later in a scheduled taskqueue.
# The default of zero(0) indicates a FreeBSD 12 default of sixteen(16) frames
# can be accepted at a time which is less than 24 kilobytes. If the server is
# not CPU limited and also receiving an agglomeration of QUIC HTTP/3 UDP
# packets, we advise increasing the budget to a maximum of 65535 packets. "man
# iflib" for more information.
#
dev.igb.0.iflib.rx_budget=65535  # (default 0, which is 16 frames)
dev.igb.1.iflib.rx_budget=65535  # (default 0, which is 16 frames)

# Fortuna pseudorandom number generator (PRNG) maximum event size is also
# referred to as the minimum pool size. Fortuna has a main generator which
# supplies the OS with PRNG data. The Fortuna generator is seeded by 32
# separate 'Fortuna' accumulation pools which each have to be filled with at
# least 'minpoolsize' bytes before being able to seed the OS with random bits.
# On FreeBSD, the default 'minpoolsize' of 64 bytes is an estimate of the
# minimum amount of bytes a new pool should contain to provide at least 128
# bits of entropy. After a pool is used in a generator reseed, that pool is
# reset to an empty string and must reach 'minpoolsize' bytes again before
# being used as a seed. Increasing the 'minpoolsize' allows higher entropy into
# the accumulation pools before being assimilated by the generator.
#
# The Fortuna authors state 64 bytes is safe enough even if an attacker
# influences some random source data. To be a bit more paranoid, we increase
# the 'minpoolsize' to 128 bytes so each pool will provide an absolute minimum
# of 256 bits of entropy, but realistically closer to 1024 bits of entropy, for
# each of the 32 Fortuna accumulation pools. Values of 128 bytes and 256 bytes
# are reasonable when coupled with a dedicated hardware based PRNG like the
# fast source Intel Secure Key RNG (PURE_RDRAND). Do not make the pool value
# too large as this will delay the reseed even if very good random sources are
# available. https://www.schneier.com/academic/paperfiles/fortuna.pdf
#
# FYI: on FreeBSD 11, values over 64 can incur additional reboot time to
# populate the pools during the "Feeding entropy:" boot stage. For example, a
# pool size value of 256 can add an additional 90 seconds to boot the machine.
# FreeBSD 12 has been patched to not incur the boot delay issue with larger
# pool values.
#
kern.random.fortuna.minpoolsize=128  # (default 64)

# Entropy is the amount of order, disorder or chaos observed in a system which
# can be observed by FreeBSD and fed though Fortuna to the accumulation pools.
# Setting the harvest.mask to 67583 allows the OS to harvest entropy from any
# source including peripherals, network traffic, the universal memory allocator
# (UMA) and interrupts (SWI), but be warned, setting the harvest mask to 67583
# will limit network throughput to less than a gigabit even on modern hardware.
# When running a ten(10) gigabit network with more than four(4) real CPU cores
# and more than four(4) network card queues it is recommended to reduce the
# harvest mask to 33119 to disable UMA. FS_ATIME, INTERRUPT and NET_ETHER
# entropy sources in order to achieve peak packets per second (PPS). By
# default, Fortuna will use a CPU's 'Intel Secure Key RNG' if available in
# hardware (PURE_RDRAND). Use "sysctl kern.random.harvest" to check the
# symbolic entropy sources being polled; disabled items are listed in square
# brackets. A harvest mask of 33119 is only around four(4%) more efficient than
# the default mask of 33247 at the maximum packets per second of the interface.
#
#kern.random.harvest.mask=351    # (default 511,   FreeBSD 11 and 12 without Intel Secure Key RNG)
#kern.random.harvest.mask=65887  # (default 66047, FreeBSD 12 with Intel Secure Key RNG)
kern.random.harvest.mask=33119   # (default 33247, FreeBSD 13 with Intel Secure Key RNG)


#
# HardenedBSD and DoS mitigation
#
hw.kbd.keymap_restrict_change=4    # disallow keymap changes for non-privileged users (default 0)
kern.elf32.allow_wx=0              # disallow pages to be mapped writable and executable, enforce W^X memory mapping policy for 32 bit user processes (default 1, enabled/allow needed for chrome, libreoffice and go apps)
kern.elf64.allow_wx=0              # disallow pages to be mapped writable and executable, enforce W^X memory mapping policy for 64 bit user processes (default 1, enabled/allow needed for chrome, libreoffice and go apps)
kern.ipc.shm_use_phys=1            # lock shared memory into RAM and prevent it from being paged out to swap (default 0, disabled)
kern.msgbuf_show_timestamp=1       # display timestamp in msgbuf (default 0)
kern.randompid=1                   # calculate PIDs by the modulus of an integer, set to one(1) to auto random (default 0)
net.bpf.optimize_writers=1         # bpf is write-only unless program explicitly specifies the read filter (default 0)
net.inet.icmp.drop_redirect=1      # no redirected ICMP packets (default 0)
net.inet.ip.check_interface=1      # verify packet arrives on correct interface (default 0)
net.inet.ip.portrange.first=32768  # use ports 32768 to portrange.last for outgoing connections (default 10000)
net.inet.ip.portrange.randomcps=9999 # use random port allocation if less than this many ports per second are allocated (default 10)
net.inet.ip.portrange.randomtime=1 # seconds to use sequental port allocation before switching back to random (default 45 secs)
net.inet.ip.random_id=1            # assign a random IP id to each packet leaving the system (default 0)
net.inet.ip.redirect=0             # do not send IP redirects (default 1)
net.inet6.ip6.redirect=0           # do not send IPv6 redirects (default 1)
net.inet.tcp.blackhole=2           # drop tcp packets destined for closed ports (default 0)
net.inet.tcp.drop_synfin=1         # SYN/FIN packets get dropped on initial connection (default 0)
net.inet.tcp.fast_finwait2_recycle=1 # recycle FIN/WAIT states quickly, helps against DoS, but may cause false RST (default 0)
net.inet.tcp.fastopen.client_enable=0 # disable TCP Fast Open client side, enforce three way TCP handshake (default 1, enabled)
net.inet.tcp.fastopen.server_enable=0 # disable TCP Fast Open server side, enforce three way TCP handshake (default 0)
net.inet.tcp.finwait2_timeout=1000 # TCP FIN_WAIT_2 timeout waiting for client FIN packet before state close (default 60000, 60 sec)
net.inet.tcp.icmp_may_rst=0        # icmp may not send RST to avoid spoofed icmp/udp floods (default 1)
net.inet.tcp.keepcnt=2             # amount of tcp keep alive probe failures before socket is forced closed (default 8)
net.inet.tcp.keepidle=62000        # time before starting tcp keep alive probes on an idle, TCP connection (default 7200000, 7200 secs)
net.inet.tcp.keepinit=5000         # tcp keep alive client reply timeout (default 75000, 75 secs)
net.inet.tcp.msl=2500              # Maximum Segment Lifetime, time the connection spends in TIME_WAIT state (default 30000, 2*MSL = 60 sec)
net.inet.tcp.path_mtu_discovery=0  # disable for mtu=1500 as most paths drop ICMP type 3 packets, but keep enabled for mtu=9000 (default 1)
net.inet.udp.blackhole=1           # drop udp packets destined for closed sockets (default 0)
net.inet.udp.recvspace=1048576     # UDP receive space, HTTP/3 webserver, "netstat -sn -p udp" and increase if full socket buffers (default 42080)
security.bsd.hardlink_check_gid=1  # unprivileged processes may not create hard links to files owned by other groups, DISABLE for mailman (default 0)
security.bsd.hardlink_check_uid=1  # unprivileged processes may not create hard links to files owned by other users,  DISABLE for mailman (default 0)
security.bsd.see_other_gids=0      # groups only see their own processes. root can see all (default 1)
security.bsd.see_other_uids=0      # users only see their own processes. root can see all (default 1)
security.bsd.stack_guard_page=1    # insert a stack guard page ahead of growable segments, stack smashing protection (SSP) (default 0)
security.bsd.unprivileged_proc_debug=0 # unprivileged processes may not use process debugging (default 1)
security.bsd.unprivileged_read_msgbuf=0 # unprivileged processes may not read the kernel message buffer (default 1)


# ZFS Tuning for PCIe NVMe M.2 and 64GB system RAM
# book: FreeBSD Mastery: ZFS By Michael W Lucas and Allan Jude
# https://www.pugetsystems.com/labs/articles/Samsung-950-Pro-M-2-Additional-Cooling-Testing-795/
# http://dtrace.org/blogs/ahl/2012/12/13/zfs-fundamentals-transaction-groups/
# http://dtrace.org/blogs/ahl/2013/12/27/zfs-fundamentals-the-write-throttle/
# http://bit.csc.lsu.edu/~fchen/publications/papers/hpca11.pdf
# http://dtrace.org/blogs/ahl/2014/08/31/openzfs-tuning/
# https://www.freebsd.org/doc/handbook/zfs-advanced.html
# https://calomel.org/zfs_freebsd_root_install.html
#
# NVMe drive        : Samsung 960 EVO 1TB PCIe 3.0 ×4 NVMe M.2 (MZ-V6E1T0BW)
# before zfs tuning : reads 1.87 GB/s  writes 1.86 GB/s  scrub 1.88 GB/s  19.2K IOPs
#  after zfs tuning : reads 3.11 GB/s  writes 1.95 GB/s  scrub 3.11 GB/s   3.8K IOPs  :)
#
# NVMe drive        : ADATA XPG SX8200 Pro 1TB PCIe 3.0 ×4 NVMe M.2 (ASX8200PNP-1TT-C)
# before zfs tuning : reads 1.88 GB/s  writes 1.86 GB/s  scrub 1.88 GB/s  19.3K IOPs
#  after zfs tuning : reads 3.27 GB/s  writes 2.62 GB/s  scrub 3.27 GB/s   2.6K IOPs  :)

vfs.zfs.delay_min_dirty_percent=98  # write throttle when dirty "modified" data reaches 98% of dirty_data_max (default 60%)
vfs.zfs.dirty_data_sync_percent=95  # force commit Transaction Group (TXG) if dirty_data reaches 95% of dirty_data_max (default 20%)
vfs.zfs.min_auto_ashift=12          # newly created pool ashift, set to 12 for 4K and 13 for 8k alignment, zdb (default 9, 512 byte, ashift=9)
vfs.zfs.trim.txg_batch=128          # max number of TRIMs per top-level vdev (default 32)
vfs.zfs.txg.timeout=75              # force commit Transaction Group (TXG) at 75 secs, increase to aggregated more data (default 5 sec)
vfs.zfs.vdev.def_queue_depth=128    # max number of outstanding I/Os per top-level vdev (default 32)
vfs.zfs.vdev.write_gap_limit=0      # max gap between any two aggregated writes, 0 to minimize frags (default 4096, 4KB)

 ZFS Tuning: The plan is to use large amounts of RAM for dirty_data_max to
# buffer incoming data before ZFS must commit the data in the next Transaction
# Group (TXG) to the physical drives in the pool. TXG commits are sequential by
# design; the incoming random write traffic cached between TXG commits is
# sequential when written to disk. When the server is able to keep more dirty
# "modified" data in RAM before the next TXG commit, there is a greater chance
# of long sequential writes without holes. These long sequential stripes of
# written data also result in significantly faster sequential reads.

# ZFS will trigger a forced TXG commit when either the temporal limit
# txg.timeout or the dirty data capacity limit dirty_data_sync_pct is reached.
# Increasing these two(2) limits will allow the system to collect more
# uncommitted data in RAM in order to write to the vdev in efficient sequential
# stripes. But, understand, if the server losses power or crashes we lose all
# dirty data in RAM not previously committed; so make sure to be on an
# Uninterruptible Power Supply (UPS). A manual "sync" as well as a "shutdown"
# or "poweroff" will always force a commit of all data in RAM to disk.

# Dirty "modified" data in RAM can be read from, written to and modified even
# before the data is committed to disk. If the data set is rapidly changing,
# like during database transactions or bittorrent traffic, the changes will be
# made solely to RAM in between TXG commits. Only the latest copy of the data
# in RAM will be written to disk on TXG commit which is a good argument for an
# extended txg.timeout.
 
# The number of outstanding I/Os per top-level vdev should be set to the
# maximum Queue Depth of the storage device times the number of threads
# supported by the storage device. According to the white sheets for NVMe
# devices, the queue depth is 32 and concurrent thread support is four (QD 32
# Thread 4). Set the vdev.def_queue_depth to a queue depth of 32 (Q32) times
# four(4) threads times one(1) NVMe drive to equal 128 max number of outstanding
# I/Os per top-level vdev. (32_queues_*_4_threads_*_1_drive=128).

# Make sure to never, ever reach the dirty_data_sync_pct capacity limit
# especially if the zfs logbias is set to "latency". Logbias latency will
# double write the same incoming data to ZIL and to the disk when
# dirty_data_sync_pct is reached halving throughput. Take a look at zfs logbias
# "throughput" to avoid these double writes. When the server is accepting data
# on a 1Gbit network interface the dirty_data_sync_pct should be larger than
# the true incoming throughput of the network times the txg.timeout; 118MB/sec
# times 75 seconds will require 8.85 gigabytes of dirty_data_max RAM space
# which is well below 95% of dirty_data_max at 15.2 gigabytes.

# When determining the size of the dirty_data_max look at the amount of fast,
# first and second tier cache available in the NVMe drives. All of the data in
# a completely filled dirty_data_max cache should be able to be committed to
# the drive well before the next txg.timeout even if a saturated network is
# concurrently writing data to dirty_data_max.
#
# The ADATA XPG SX8200 Pro 1TB NVMe has 165 gigabytes of first tier SLC cache
# and 500 gigabytes of of second tier MLC, dynamic cache. The SX8200 can write
# at 2.62 gigabytes per second to the first tier SLC cache when the drive is
# properly cooled, meaning 14.16 gigabytes of dirty_data_sync_pct can be
# committed to the NVMe drive in five(5) seconds, well before the next
# txg.timeout of 75 seconds.
#
# The Samsung 960 EVO NVMe 1TB has six(6) gigabytes of first tier cache plus
# thirty six(36) gigabytes of second tier, dynamic cache. The 960 EVO can write
# at 1.95 gigabytes per second when the drive is properly cooled meaning 14.16
# gigabytes of dirty_data_sync_pct can be committed to the NVMe drive in
# seven(7) seconds, well before the next txg.timeout of 75 seconds.
#
# NVMe M.2 Cooling: Enzotech BMR-C1 passive copper heat sinks (14mm x 14mm x 14mm,
# C1100 forged copper, 8-pack) work well to cool our NVMe drives. User four(4)
# heatsinks per NVMe drive, one 14mm x 14mm copper square per silicon chip.

# The ZFS commit logic order is strictly sync_read, sync_write, async_read,
# async_write and finally scrub/resilver .

###
######
######### OFF BELOW HERE #########
#
# ZFS Tuning
#vfs.zfs.delay_scale=500000              # (default 500000 ns, nanoseconds)
#vfs.zfs.dirty_data_max=17179869184      # dirty_data can use up to 16GB RAM, equal to dirty_data_max_max (default, 10% of RAM or up to 4GB)
#vfs.zfs.dirty_data_sync=12348030976     # force commit Transaction Group (TXG) if dirty_data reaches 11.5GB (default 67108864, 64MB, FreeBSD 12.0; replaced by vfs.zfs.dirty_data_sync_pct on FreeBSD 12.1)
#vfs.zfs.no_scrub_prefetch=0             # disable prefetch on scrubs (default 0)
#vfs.zfs.nopwrite_enabled=1              # enable nopwrite feature, requires sha256 / sha512 checksums (default 1)
#vfs.zfs.prefetch_disable=0              # file-level prefetching, disable if zfs-stats prefetch stats below 10% (default 0 if RAM greater than 4GB)
#vfs.zfs.resilver_delay=2                # number of pause ticks to delay resilver on a busy pool (default 2, kern.hz 1000 ticks/sec / 2 = 500 IOPS)
#vfs.zfs.scrub_delay=4                   # number of pause ticks to delay scrub on a busy pool (default 4, kern.hz 1000 ticks/sec / 4 = 250 IOPS)
#vfs.zfs.sync_pass_rewrite=2             # rewrite new bps starting in this pass (default 2)
#vfs.zfs.trim.txg_delay=2           # delay TRIMs by up to this many TXGs, trim.txg_delay * txg.timeout ~= 240 secs (default 32, 32*5secs=160 secs)
#vfs.zfs.vdev.aggregation_limit=1048576  # aggregated eight(8) TXGs into a single sequential TXG, make divisible by largest pool recordsize (default 131072, 128KB, FreeBSD 12.0; default 1048576 on FreeBSD 12.1)
#vfs.zfs.vdev.async_read_max_active=3    # max async_read I/O requests per device in pool (default 3)
#vfs.zfs.vdev.async_read_min_active=1    # min async_read I/O requests per device in pool (default 1)
#vfs.zfs.vdev.async_write_active_max_dirty_percent=60 # percent dirty_data_max cached when max_active I/Os are all active (default 60%)
#vfs.zfs.vdev.async_write_active_min_dirty_percent=30 # percent dirty_data_max cached before linearly rising to max_active I/Os (default 30%)
#vfs.zfs.vdev.async_write_max_active=10  # max async_write I/O requests per device in pool (default 10)
#vfs.zfs.vdev.async_write_min_active=1   # min async_write I/O requests per device in pool (default 1)
#vfs.zfs.vdev.max_active=1000            # max I/Os of any type active per device in pool (default 1000)
#vfs.zfs.vdev.read_gap_limit=32768       # max gap between any two reads being aggregated (default 32768, 32KB)
#vfs.zfs.vdev.scrub_max_active=2         # max scrub I/Os active on each device (default 2)
#vfs.zfs.vdev.scrub_min_active=1         # min scrub I/Os active on each device (default 1)
#vfs.zfs.vdev.sync_read_max_active=10    # max sync_read I/O requests per device in pool (default 10)
#vfs.zfs.vdev.sync_read_min_active=10    # min sync_read I/O requests per device in pool (default 10)
#vfs.zfs.vdev.sync_write_max_active=10   # max sync_write I/O requests per device in pool (default 10)
#vfs.zfs.vdev.sync_write_min_active=10   # min sync_write I/O requests per device in pool (default 10)
#vfs.zfs.vdev.trim_max_active=64         # max trim I/O requests per device in pool (default 64)
#vfs.zfs.vdev.write_gap_limit=4096       # max gap between any two writes being aggregated, 16K bittorrent, 4k nfs, 4k mysql (default 4096, 4KB)

# ZFS L2ARC tuning - If you have read intensive workloads and limited RAM make
# sure to use an SSD for your L2ARC. Verify noprefetch is enabled(1) and
# increase the speed at which the system can fill the L2ARC device. By default,
# when the L2ARC is being populated FreeBSD will only write at 16MB/sec to the
# SSD. 16MB calculated by adding the speed of write_boost and write_max.
# 16MB/sec is too slow as many SSD's made today which can easily sustain
# 500MB/sec. It is recommend to set both write_boost and write_max to at least
# 256MB each so the L2ARC can be quickly seeded. Contrary to myth, enterprise
# class SSDs can last for many years under constant read/write abuse of a web
# server.
#vfs.zfs.l2arc_noprefetch=1          # (default 1)
#vfs.zfs.l2arc_write_boost=268435456 # (default 8388608)
#vfs.zfs.l2arc_write_max=268435456   # (default 8388608)

# General Security and DoS mitigation
#hw.hn.enable_udp4cs=1              # Offload UDP/IPv4 checksum to network card (default 1)
#hw.hn.enable_udp6cs=1              # Offload UDP/IPv6 checksum to network card (default 1)
#hw.ixl.enable_tx_fc_filter=1       # filter out Ethertype 0x8808, flow control frames (default 1)
#net.bpf.optimize_writers=0         # bpf are write-only unless program explicitly specifies the read filter (default 0)
#net.bpf.zerocopy_enable=0          # zero-copy BPF buffers, breaks dhcpd ! (default 0)
#net.inet.icmp.bmcastecho=0         # do not respond to ICMP packets sent to IP broadcast addresses (default 0)
#net.inet.icmp.log_redirect=0       # do not log redirected ICMP packet attempts (default 0)
#net.inet.icmp.maskfake=0           # do not fake reply to ICMP Address Mask Request packets (default 0)
#net.inet.icmp.maskrepl=0           # replies are not sent for ICMP address mask requests (default 0)
#net.inet.ip.accept_sourceroute=0   # drop source routed packets since they can not be trusted (default 0)
#net.inet.ip.portrange.randomized=1 # randomize outgoing upper ports (default 1)
#net.inet.ip.process_options=1      # process IP options in the incoming packets (default 1)
#net.inet.ip.sourceroute=0          # if source routed packets are accepted the route data is ignored (default 0)
#net.inet.ip.stealth=0              # do not reduce the TTL by one(1) when a packets goes through the firewall (default 0)
#net.inet.tcp.always_keepalive=1    # tcp keep alive detection for dead peers, keepalive can be spoofed (default 1)
#net.inet.tcp.ecn.enable=1          # Explicit Congestion Notification (ECN) allowed for incoming and outgoing connections (default 2)
#net.inet.tcp.keepintvl=75000       # time between tcp.keepcnt keep alive probes (default 75000, 75 secs)
#net.inet.tcp.maxtcptw=50000        # max number of tcp time_wait states for closing connections (default ~27767)
#net.inet.tcp.nolocaltimewait=0     # remove TIME_WAIT states for the loopback interface (default 0)
#net.inet.tcp.reass.maxqueuelen=100 # Max number of TCP Segments per Reassembly Queue (default 100)
#net.inet.tcp.rexmit_min=30         # reduce unnecessary TCP retransmissions by increasing timeout, min+slop (default 30 ms)
#net.inet.tcp.rexmit_slop=200       # reduce the TCP retransmit timer, min+slop (default 200ms)
#net.inet.udp.checksum=1            # hardware should generate UDP checksums (default 1)
#net.inet.udp.maxdgram=16384        # Maximum outgoing UDP datagram size to match MTU of localhost (default 9216)
#net.inet.sctp.blackhole=2          # drop stcp packets destined for closed ports (default 0)

# RACK TCP Stack: Netflix's TCP Recent ACKnowledgment (Recent ACK) and Tail
# Loss Probe (TLP) for improved Retransmit TimeOut response. RACK uses the
# notion of time, instead of packet or sequence counts, to detect TCP losses
# for connections supporting per-packet timestamps and selective acknowledgment
# (SACK). Connections that do not support SACK are automatically serviced by
# the default, base FreeBSD TCP stack. Use "sysctl
# net.inet.tcp.functions_available" to show available TCP stacks loaded by the
# kernel. FYI: introduced in FreeBSD 12; the kernel must be rebuilt with
# additional TCP stacks (makeoptions WITH_EXTRA_TCP_STACKS=1) and the high
# precision TCP timer (options TCPHPTS).
# https://tools.ietf.org/html/draft-ietf-tcpm-rack-04
#
#net.inet.tcp.functions_default=rack  # (default freebsd)

# RACK TCP Stack: The method used for Tail Loss Probe (TLP) calculations.
# https://tools.ietf.org/html/draft-ietf-tcpm-rack-04
#
# FYI: Needs Testing
#
#net.inet.tcp.rack.tlpmethod=3  # (default 2, 0=no-de-ack-comp, 1=ID, 2=2.1, 3=2.2)

# RACK TCP Stack: send a Reset (RST) packet as soon as all data is sent and,
# perhaps, before all pending data is acknowledged (ACK) by the client. This
# may help on busy servers to close connections quickly thus freeing up
# resources.
#
# FYI: Needs Testing
#
#net.inet.tcp.rack.data_after_close=0  # (default 1)

# H-TCP congestion control: The Hamilton TCP (HighSpeed-TCP) algorithm is a
# packet loss based congestion control and is more aggressive pushing up to max
# bandwidth (total BDP) and favors hosts with lower TTL / VARTTL than
# "newreno". The default congrestion control "newreno" works well in most
# conditions and enabling H-TCP may only gain a you few percentage points of
# throughput.
# http://www.sigcomm.org/sites/default/files/ccr/papers/2008/July/1384609-1384613.pdf
# make sure to also add 'cc_htcp_load="YES"' to /boot/loader.conf then check
# available congestion control options with "sysctl net.inet.tcp.cc.available"
#net.inet.tcp.cc.algorithm=htcp  # (default newreno)

# H-TCP congestion control: adaptive back off will increase bandwidth
# utilization by adjusting the additive-increase/multiplicative-decrease (AIMD)
# backoff parameter according to the amount of buffers available on the path.
# adaptive backoff ensures no queue along the path will remain completely empty
# after a packet loss event which increases buffer efficiency.
#net.inet.tcp.cc.htcp.adaptive_backoff=1  # (default 0 ; disabled)

# H-TCP congestion control: RTT scaling will increase the fairness between
# competing TCP flows traversing different RTT paths through a common
# bottleneck. rtt_scaling increases the Congestion Window Size (CWND)
# independent of path round-trip time (RTT) leading to lower latency for
# interactive sessions when the connection is saturated by bulk data transfers.
# Default is 0 (disabled)
#net.inet.tcp.cc.htcp.rtt_scaling=1  # (default 0 ; disabled)

# CAIA-Delay Gradient (CDG) is a hybrid TCP congestion control algorithm which
# reacts to both packet loss and inferred queuing delay. CDG attempts to
# operate as a temporal, delay-based algorithm where possible while utilizing
# heuristics to detect loss-based TCP cross traffic and compete effectively
# against other packet loss based congestion controls on the network.
#
# During time-based operation, CDG uses a delay-gradient based probabilistic
# backoff mechanism to infer non-congestion related packet losses. CDG
# periodically switches to loss-based operation when it detects a configurable
# number of consecutive delay-based backoffs have had no measurable effect.
# During packet loss-based operation, CDG essentially reverts to
# cc_newreno-like behaviour. CDG oscillates between temporal, delay-based
# operation and packet loss-based operation as dictated by network conditions.
#
# Load the kernel module by adding 'cc_cdg_load="YES"' to /boot/loader.conf and
# on next reboot verify the available congestion control options with "sysctl
# net.inet.tcp.cc.available"
# http://caia.swin.edu.au/cv/dahayes/content/networking2011-cdg-preprint.pdf
# http://caia.swin.edu.au/reports/110729A/CAIA-TR-110729A.pdf
# https://lwn.net/Articles/645115/
#net.inet.tcp.cc.algorithm=cdg  # (default newreno)

# CAIA-Delay Gradient (CDG) alpha_inc enables an experimental mode where the
# CDG window increase factor (alpha) is increased by one(1) MSS every alpha_inc
# RTTs during congestion avoidance mode. Setting alpha_inc to 1 results in the
# most aggressive growth of the window increase factor over time while a higher
# alpha_inc value results in slower growth.
#net.inet.tcp.cc.cdg.alpha_inc=1  # (default 0, experimental mode disabled)

# CUBIC congestion control: is a time based congestion control algorithm
# optimized for high speed, high latency networks and a decent choice for
# networks with minimal packet loss; most hard wired internet connections are
# in this catagory. CUBIC can improve startup throughput of bulk data transfers
# and burst transfers of a web server by up to 2x compared to packet loss based
# algorithms like newreno and H-TCP. FreeBSD 11.1 updated CUBIC code to match
# the 2016 RFC including the slow start algorithm, HyStart. CUBIC Hystart uses
# two heuristics, based on RTT, to exit slow start earlier, but before losses
# start to occur. Add 'cc_cubic_load="YES"' to /boot/loader.conf and check
# available congestion control options with "sysctl net.inet.tcp.cc.available".
# https://labs.ripe.net/Members/gih/bbr-tcp
#net.inet.tcp.cc.algorithm=cubic  # (default newreno)

# Firewall: Ip Forwarding to allow packets to traverse between interfaces and
# is used for firewalls, bridges and routers. When fast IP forwarding is also
# enabled, IP packets are forwarded directly to the appropriate network
# interface with direct processing to completion, which greatly improves the
# throughput. All packets for local IP addresses, non-unicast, or with IP
# options are handled by the normal IP input processing path. All features of
# the normal (slow) IP forwarding path are supported by fast forwarding
# including firewall (through pfil(9) hooks) checking, except ipsec tunnel
# brokering. The IP fast forwarding path does not generate ICMP redirect or
# source quench messages though. Compared to normal IP forwarding, fast
# forwarding can give a speedup of 40 to 60% in packet forwarding performance
# which is great for interactive connections like online games or VOIP where
# low latency is critical. These options are already enabled if
# gateway_enable="YES" is in /etc/rc.conf
#net.inet.ip.forwarding=1      # (default 0)
#net.inet.ip.fastforwarding=1  # (default 0)  FreeBSD 11 enabled fastforwarding by default
#net.inet6.ip6.forwarding=1    # (default 0)

# Increase the localhost buffer space as well as the maximum incoming and
# outgoing raw IP datagram size to 16384 bytes (2^14 bytes) which is the same
# as the MTU for the localhost interface, "ifconfig lo0". The larger buffer
# space should allow services which listen on localhost, like web or database
# servers, to more efficiently move data to the network buffers. 
#net.inet.raw.maxdgram=16384       # (default 9216)
#net.inet.raw.recvspace=16384      # (default 9216)
#net.local.stream.sendspace=16384  # (default 8192)
#net.local.stream.recvspace=16384  # (default 8192)

# The TCPT_REXMT timer is used to force retransmissions. TCP has the
# TCPT_REXMT timer set whenever segments have been sent for which ACKs are
# expected, but not yet received. If an ACK is received which advances
# tp->snd_una, then the retransmit timer is cleared (if there are no more
# outstanding segments) or reset to the base value (if there are more ACKs
# expected). Whenever the retransmit timer goes off, we retransmit one
# unacknowledged segment, and do a backoff on the retransmit timer.
# net.inet.tcp.persmax=60000 # (default 60000)
# net.inet.tcp.persmin=5000  # (default 5000)

# Drop TCP options from 3rd and later retransmitted SYN
# net.inet.tcp.rexmit_drop_options=0  # (default 0)

# Enable tcp_drain routine for extra help when low on mbufs
# net.inet.tcp.do_tcpdrain=1 # (default 1)

# Myricom mxge(4): the maximum number of slices the driver will attempt to
# enable if enough system resources are available at boot. A slice is comprised
# of a set of receive queues and an associated interrupt thread. Multiple
# slices should be used when the network traffic is being limited by the
# processing speed of a single CPU core. When using multiple slices, the NIC
# hashes traffic to different slices based on the value of
# hw.mxge.rss_hashtype. Using multiple slices requires that your motherboard
# and Myri10GE NIC both be capable of MSI-X. The maximum number of slices
# is limited to the number of real CPU cores divided by the number of mxge
# network ports.
#hw.mxge.max_slices="1"  # (default 1, which uses a single cpu core)

# Myricom mxge(4): when multiple slices are enabled, the hash type determines
# how incoming traffic is steered to each slice. A slice is comprised of a set
# of receive queues and an associated interrupt thread. Hashing is disabled
# when using a single slice (hw.mxge.max_slices=1). The options are: ="1"
# hashes on the source and destination IPv4 addresses. ="2" hashes on the
# source and destination IPv4 addresses and also TCP source and destination
# ports. ="4" is the default and hashes on the TCP or UDP source ports. A value
# to "4" will more evenly distribute the flows over the slices. A value of "1"
# will lock client source ips to a single slice.
#hw.mxge.rss_hash_type="4"  # (default 4)

# Myricom mxge(4): flow control manages the rate of data transmission between
# two nodes preventing a fast sender from overwhelming a slow receiver.
# Ethernet "PAUSE" frames pause transmission of all traffic on a physical link,
# not just the individual flow causing the problem. By disabling physical link
# flow control the link instead relies on TCP's internal flow control which is
# peer based on IP address and more fair to each flow. The mxge options are:
# (0=No Flow Control) (1=Full Flow Control, Default). A value of zero(0)
# disables ethernet flow control on the Myricom mxge(4) interface.
# http://virtualthreads.blogspot.com/2006/02/beware-ethernet-flow-control.html
#hw.mxge.flow_control_enabled=0  # (default 1, enabled)

# The number of frames the NIC's receive (rx) queue will accept before
# triggering a kernel inturrupt. If the NIC's queue is full and the kernel can
# not process the packets fast enough then the packets are dropped. Use "sysctl
# net.inet.ip.intr_queue_drops" and "netstat -Q" and increase the queue_maxlen
# if queue_drops is greater then zero(0). The real problem is the CPU or NIC is
# not fast enough to handle the traffic, but if you are already at the limit of
# your network then increasing these values will help.
#net.inet.ip.intr_queue_maxlen=2048  # (default 256)
#net.route.netisr_maxqlen=2048       # (default 256)

# Intel igb(4): freebsd limits the the number of received packets a network
# card can process to 100 packets per interrupt cycle. This limit is in place
# because of inefficiencies in IRQ sharing when the network card is using the
# same IRQ as another device. When the Intel network card is assigned a unique
# IRQ (dmesg) and MSI-X is enabled through the driver (hw.igb.enable_msix=1)
# then interrupt scheduling is significantly more efficient and the NIC can be
# allowed to process packets as fast as they are received. A value of "-1"
# means unlimited packet processing. There is no need to set these options if
# hw.igb.rx_process_limit is already defined.
#dev.igb.0.rx_processing_limit=-1  # (default 100)
#dev.igb.1.rx_processing_limit=-1  # (default 100)

# Intel igb(4): Energy-Efficient Ethernet (EEE) is intended to reduce system
# power consumption up to 80% by setting the interface to a low power mode
# during periods of network inactivity. When the NIC is in low power mode this
# allows the CPU longer periods of time to also go into a sleep state thus
# lowering overall power usage. The problem is EEE can cause periodic packet
# loss and latency spikes when the interface transitions from low power mode.
# Packet loss from EEE will not show up in the missed_packets or dropped
# counter because the packet was not dropped, but lost by the network card
# during the transition phase. The Intel i350-T2 only requires 4.4 watts with
# both network ports active so we recommend disabling EEE especially on a
# server unless power usage is of higher priority. Verify DMA Coalesce is
# disabled (dev.igb.0.dmac=0) which is the default. WARNING: enabling EEE will
# significantly delay DHCP leases and the network interface will flip a few
# times on boot. https://en.wikipedia.org/wiki/Energy-Efficient_Ethernet
#dev.igb.0.eee_disabled=1  # (default 0, enabled)
#dev.igb.1.eee_disabled=1  # (default 0, enabled)

# Spoofed packet attacks may be used to overload the kernel route cache. A
# spoofed packet attack uses random source IPs to cause the kernel to generate
# a temporary cached route in the route table, Route cache is an extraneous
# caching layer mapping interfaces to routes to IPs and saves a lookup to the
# Forward Information Base (FIB); a routing table within the network stack. The
# IPv4 routing cache was intended to eliminate a FIB lookup and increase
# performance. While a good idea in principle, unfortunately it provided a very
# small performance boost in less than 10% of connections and opens up the
# possibility of a DoS vector. Setting rtexpire and rtminexpire to ten(10)
# seconds should be sufficient to protect the route table from attack.
# http://www.es.freebsd.org/doc/handbook/securing-freebsd.html
# Route cache options were removed in FreeBSD 11.0
#net.inet.ip.rtexpire=10      # (default 3600)
#net.inet.ip.rtminexpire=10  # (default 10  )
#net.inet.ip.rtmaxcache=128  # (default 128 )

# somaxconn is the OS buffer, backlog queue depth for accepting new incoming TCP
# connections. An application will have its own, separate max queue length
# (maxqlen) which can be checked with "netstat -Lan". The default is 128
# connections per application thread. Lets say your Nginx web server normally
# receives 100 connections/sec and is single threaded application. If clients
# are bursting in at a total of 250 connections/sec you may want to set the
# somaxconn at 512 to be a 512 deep connection buffer so the extra 122 clients
# (250-128=122) do not get denied service since you would have 412
# (512-100=412) extra queue slots. Also, a large listen queue will do a better
# job of avoiding Denial of Service (DoS) attacks if, and only if, your
# application can handle the TCP load at the cost of more RAM and CPU time.
# Nginx sets is backlog queue to the same as the OS somaxconn by default.
# Note: "kern.ipc.somaxconn" is not shown in "sysctl -a" output, but searching
# for "kern.ipc.soacceptqueue" gives the same value and both directives stand
# for the same buffer value.
#kern.ipc.soacceptqueue=1024  # (default 128 ; same as kern.ipc.somaxconn)

# The TCP window scale (rfc3390) option is used to increase the TCP receive
# window size above its maximum value of 65,535 bytes (64k). TCP Time Stamps
# (rfc1323) allow nearly every segment, including retransmissions, to be
# accurately timed at negligible computational cost. Both options should be
# enabled by default. Enhancing TCP Loss Recovery (rfc3042) says on packet
# loss, trigger the fast retransmit algorithm instead of tcp timeout.
#net.inet.tcp.rfc1323=1  # (default 1)
#net.inet.tcp.rfc3042=1  # (default 1)
#net.inet.tcp.rfc3390=1  # (default 1)

# FreeBSD limits the maximum number of TCP reset (RST) and ICMP Unreachable
# packets the server will send every second. Limiting reply packets helps curb
# the effects of Brute-force TCP denial of service (DoS) attacks and UDP port
# scans. Also, when Pf firewall client states expire FreeBSD will send out RST
# packets to tell the client the connection is closed. By default, FreeBSD will
# send out 200 packets per second.
#net.inet.icmp.icmplim=1  # (default 200)
#net.inet.icmp.icmplim_output=0  # (default 1)

# Selective Acknowledgment (SACK) allows the receiver to inform the sender of
# packets which have been received and if any packets were dropped. The sender
# can then selectively retransmit the missing data without needing to
# retransmit entire blocks of data that have already been received
# successfully. SACK option is not mandatory and support must be negotiated
# when the connection is established using TCP header options. An attacker
# downloading large files can abuse SACK by asking for many random segments to
# be retransmitted. The server in response wastes system resources trying to
# fulfill superfluous requests. If you are serving small files to low latency
# clients then SACK can be disabled. If you see issues of flows randomly
# pausing, try disabling SACK to see if there is equipment in the path which
# does not handle SACK correctly.
#net.inet.tcp.sack.enable=1  # (default 1)

# host cache is the client's cached tcp connection details and metrics (TTL,
# SSTRESH and VARTTL) the server can use to improve future performance of
# connections between the same two hosts. When a tcp connection is completed,
# our server will cache information about the connection until an expire
# timeout. If a new connection between the same client is initiated before the
# cache has expired, the connection will use the cached connection details to
# setup the connection's internal variables. This pre-cached setup allows the
# client and server to reach optimal performance significantly faster because
# the server will not need to go through the usual steps of re-learning the
# optimal parameters for the connection. Unfortunately, this can also make
# performance worse because the hostcache will apply the exception case to
# every new connection from a client within the expire time. In other words, in
# some cases, one person surfing your site from a mobile phone who has some
# random packet loss can reduce your server's performance to this visitor even
# when their temporary loss has cleared.  3900 seconds allows clients who
# connect regularly to stay in our hostcache. To view the current host cache
# stats use "sysctl net.inet.tcp.hostcache.list" . If you have
# "net.inet.tcp.hostcache.cachelimit=0" like in our /boot/loader.conf example
# then this expire time is negated and not uesd.
#net.inet.tcp.hostcache.expire=3900  # (default 3600)

# By default, acks are delayed by 100 ms or sent every other packet in order to
# improve the chance of being added to another returned data packet which is
# full. This method can cut the number of tiny packets flowing across the
# network and is efficient. But, delayed ACKs cause issues on modern, short
# hop, low latency networks. TCP works by increasing the congestion window,
# which is the amount of data currently traveling on the wire, based on the
# number of ACKs received per time frame. Delaying the timing of the ACKs
# received results in less data on the wire, time in TCP slowstart is doubled
# and in congestion avoidance after packet loss the congestion window growth is
# slowed.  Setting delacktime higher then 100 will to slow downloads as ACKs
# are queued too long. On low latecy 10gig links we find a value of 20ms is
# optimal. http://www.tel.uva.es/personales/ignmig/pdfs/ogonzalez_NOC05.pdf
#net.inet.tcp.delayed_ack=1   # (default 1)
#net.inet.tcp.delacktime=20   # (default 100)

# security settings for jailed environments. it is generally a good idea to
# separately jail any service which is accessible by an external client like
# the web or mail server. This is especially true for public facing services.
# take a look at ezjail, http://forums.freebsd.org/showthread.php?t=16860
#security.jail.allow_raw_sockets=1       # (default 0)
#security.jail.enforce_statfs=2          # (default 2)
#security.jail.set_hostname_allowed=0    # (default 1)
#security.jail.socket_unixiproute_only=1 # (default 1)
#security.jail.sysvipc_allowed=0         # (default 0)
#security.jail.chflags_allowed=0         # (default 0)

# decrease the scheduler maximum time slice for lower latency program calls.
# by default we use stathz/10 which equals thirteen(13). also, decrease the
# scheduler maximum time for interactive programs as this is a dedicated
# server (default 30). Also make sure you look into "kern.hz=100" in /boot/loader.conf
#kern.sched.interact=5 # (default 30)
#kern.sched.slice=3    # (default 12)

# threads per process
#kern.threads.max_threads_per_proc=9000

# create core dump file on "exited on signal 6"
#kern.coredump=1             # (default 1)
#kern.sugid_coredump=1        # (default 0)
#kern.corefile="/tmp/%N.core" # (default %N.core)

# TCP keep alive can help detecting network errors and signaling connection
# problems. Keep alives will increase signaling bandwidth used, but as
# bandwidth utilized by signaling channels is low from its nature, the increase
# is insignificant. the system will disconnect a dead TCP connection when the
# remote peer is dead or unresponsive for: 10000 + (5000 x 8) = 50000 msec (50
# sec)
#net.inet.tcp.keepidle=10000     # (default 7200000 )
#net.inet.tcp.keepintvl=5000     # (default 75000 )
#net.inet.tcp.always_keepalive=1 # (default 1)

# UFS hard drive read ahead equivalent to 4 MiB at 32KiB block size. Easily
# increases read speeds from 60 MB/sec to 80 MB/sec on a single spinning hard
# drive. Samsung 830 SSD drives went from 310 MB/sec to 372 MB/sec (SATA 6).
# use Bonnie++ to performance test file system I/O
#vfs.read_max=128

# global limit for number of sockets in the system. If kern.ipc.numopensockets
# plus net.inet.tcp.maxtcptw is close to kern.ipc.maxsockets then increase this
# value
#kern.ipc.maxsockets = 25600

# spread tcp timer callout load evenly across cpus. We did not see any speed
# benefit from enabling per cpu timers. The default is off(0)
#net.inet.tcp.per_cpu_timers = 0

# seeding cryptographic random number generators is provided by the /dev/random
# device, which provides psudo "real" randomness. The arc4random(3) library call
# provides a pseudo-random sequence which is generally reckoned to be suitable
# for simple cryptographic use. The OpenSSL library also provides functions for
# managing randomness via functions such as RAND_bytes(3) and RAND_add(3). Note
# that OpenSSL uses the random device /dev/random for seeding automatically.
# http://manpages.ubuntu.com/manpages/lucid/man4/random.4freebsd.html
#kern.random.yarrow.gengateinterval=10  # default 10 [4..64]
#kern.random.yarrow.bins=10             # default 10 [2..16]
#kern.random.yarrow.fastthresh=192      # default 192 [64..256]
#kern.random.yarrow.slowthresh=256      # default 256 [64..256]
#kern.random.yarrow.slowoverthresh=2    # default 2 [1..5]
#kern.random.sys.seeded=1               # default 1
#kern.random.sys.harvest.ethernet=1     # default 1
#kern.random.sys.harvest.point_to_point=1 # default 1
#kern.random.sys.harvest.interrupt=1    # default 1
#kern.random.sys.harvest.swi=0          # default 0 and actually does nothing when enabled

# IPv6 Security
# For more info see http://www.fosslc.org/drupal/content/security-implications-ipv6
# Disable Node info replies
# To see this vulnerability in action run `ping6 -a sglAac ::1` or `ping6 -w ::1` on unprotected node
#net.inet6.icmp6.nodeinfo=0
# Turn on IPv6 privacy extensions
# For more info see proposal http://unix.derkeiler.com/Mailing-Lists/FreeBSD/net/2008-06/msg00103.html
#net.inet6.ip6.use_tempaddr=1
#net.inet6.ip6.prefer_tempaddr=1
# Disable ICMP redirect
#net.inet6.icmp6.rediraccept=0
# Disable acceptation of RA and auto linklocal generation if you don't use them
##net.inet6.ip6.accept_rtadv=0
##net.inet6.ip6.auto_linklocal=0

#
##
### EOF ###