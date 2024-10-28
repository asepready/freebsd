```sh
## File /boot/loader.conf

#
# Calomel.org  -|-  April 2021
#
# https://calomel.org/freebsd_network_tuning.html
#

# ZFS root boot config
#
zfs_load="YES"
vfs.root.mountfrom="zfs:zroot"

# Pf firewall kernel modules, preload
#
pf_load="YES"
pflog_load="YES"

# ZFS: the maximum upper limit of RAM used for dirty, "modified", uncommitted
# data which vfs.zfs.dirty_data_max can not exceed. The server has 64GB of RAM
# in which we will allow up to 16GB, if needed, to cache incoming data before
# TXG commit to the PCIe NVMe array. Note: the dirty_data cache is part of the
# Adaptive Replacement Cache (ARC) and can be viewed in "top" as the "Anon"
# value under ARC.
#
vfs.zfs.dirty_data_max_max="17179869184"  # (default 4294967296, 4GB)

# ZFS: max percentage of total server RAM allowed to be dirty (Anon in top).
# 25% of 64 GBytes of RAM is 16MB which is equal to vfs.zfs.dirty_data_max_max .
#
vfs.zfs.dirty_data_max_percent="25"  # (default 10 percent)

# hostcache cache limit is the number of ip addresses in the hostcache list.
# Setting the value to zero(0) stops any ip address connection information from
# being cached and negates the need for "net.inet.tcp.hostcache.expire". We
# find disabling the hostcache increases burst data rates if a subnet was
# incorrectly graded as slow on a previous connection. A host cache entry is
# the client's cached tcp connection details and metrics (TTL, SSTRESH and
# VARTTL) the server can use to improve future performance of connections
# between the same two hosts. When a tcp connection is completed, our server
# will cache information about the connection until an expire timeout. If a new
# connection between the same client is initiated before the cache has expired,
# the connection will use the cached connection details to setup the
# connection's internal variables. This pre-cached setup allows the client and
# server to reach optimal performance significantly faster because the server
# will not need to go through the usual steps of re-learning the optimal
# parameters for the connection. To view the current host cache stats use
# "sysctl net.inet.tcp.hostcache.list"
#
net.inet.tcp.hostcache.enable="0"
net.inet.tcp.hostcache.cachelimit="0"

# Drive Labels. A diskid or gptid is a long, unique string assigned to drives
# which we find are difficult to relate to. We prefer to disable diskid's and
# gptid's and use GPT Labels, like gpt/disk0, or the raw device names, like
# nvd0p2 for the first NVMe drive, second partition. Use "glabel status" to
# display a map of GPT Labels to raw device names in order to identify the
# physical drive location. When adding new drives, try to use gpt labels
# instead of raw device names in case the drives move to different SATA, SAS or
# SCSI interface ports.
#
kern.geom.label.disk_ident.enable="0" # (default 1) diskid/DISK-ABC0123...
kern.geom.label.gptid.enable="0"      # (default 1) gptid/123abc-abc123...

# Disable Hyper Threading (HT), also known as Intel's proprietary simultaneous
# multithreading (SMT) because implementations typically share TLBs and L1
# caches between threads which is a security concern. SMT is likely to slow
# down workloads not specifically optimized for SMT if you have a CPU with more
# than two(2) real CPU cores. Secondly, multi-queue network cards are as much
# as 20% slower when network queues are bound to both real CPU cores and SMT
# virtual cores due to interrupt processing collisions.
#
machdep.hyperthreading_allowed="0"  # (default 1, allow Hyper Threading (HT))

# Enable the optimized version of the soreceive() kernel socket interface for
# stream (TCP) sockets. soreceive_stream() only does one sockbuf unlock/lock
# per receive independent of the length of data to be moved into the uio
# compared to soreceive() which unlocks/locks per *mbuf*. soreceive_stream()
# can significantly reduced CPU usage and lock contention when receiving fast
# TCP streams. Additional gains are obtained when the receiving application,
# like a web server, is using SO_RCVLOWAT to batch up some data before a read
# (and wakeup) is done. NOTE: disable net.inet.tcp.soreceive_stream when using
# rndc to update BIND DNS records otherwise the following error will trigger,
# "rndc: recv failed: host unreachable".
#
net.inet.tcp.soreceive_stream="1"  # (default 0)

# NETISR: by default, FreeBSD uses a single thread to process all network
# traffic in accordance with the strong ordering requirements found in some
# protocols, such as TCP. In order to increase potential packet processing
# concurrency, net.isr.maxthreads can be define as "-1" which will
# automatically enable netisr threads equal to the number of CPU cores in the
# machine. Now, all CPU cores can be used for packet processing and the system
# will not be limited to a single thread running on a single CPU core.
#
# The Intel igb(4) driver with queues autoconfigured (hw.igb.num_queues="0")
# and msix enabled (hw.igb.enable_msix=1) will create the maximum number of
# queues limited by the Intel igb hardware, msix messages and the number of
# CPUs in the system. Once the igb interface maximum number of queues is
# defined, an interrupt handler is bound to each of those queues on their
# respective seperate CPU cores. The igb driver then creates a separate
# single-threaded taskqueue for each queue and each queue's interrupt handler
# sends work to its associated taskqueue when the interrupt fires. Those
# taskqueues are on the same CPU core where the ethernet packets were received
# and processed by the driver. All IP (and above) processing for that packet
# will be performed on the same CPU the queue interrupt was bound to thus
# gaining CPU affinity for that flow.
#
# A single net.isr workflow on a Core i5 CPU can process ~4Gbit/sec of traffic
# which is adequate for a dual 1Gbit/sec firewall interface. On a system
# supporting mostly non-ordered protocols such as UDP (HTTP/3, Google's QUIC or
# NTPd) you may want to assign more queues and bind them to their own CPU core.
# For a 10GBit/sec interface, we recommend a modern CPU with at least four(4)
# real CPU cores and enable net.isr.maxthreads="-1". Use "netstat -Q" to check
# bindings and work streams. "vmstat -i" for interrupts per network queue.
# https://lists.freebsd.org/pipermail/freebsd-net/2014-April/038470.html
#
# Do Not enable net.isr.maxthreads on Chelsio T5/T4 cards.
#
net.isr.maxthreads="-1"  # (default 1, single threaded)

# NETISR: Kernel network dispatch service. Enforced ordering will limit the
# opportunity for concurrency, but maintain the strong ordering requirement
# found in protocols such as TCP. Of related concern is CPU affinity; it is
# desirable to process all data associated with a particular stream on the same
# CPU core over time in order to avoid acquiring locks associated with the
# connection on different CPUs, keep connection data in one L1/L2 cache, and to
# generally encourage associated user threads to live on the same CPU as the
# stream. It's also desirable to avoid lock migration and contention where
# locks are associated with more than one flow.
#
# By default, FreeBSD uses a single net.isr thread (net.isr.maxthreads="1") for
# strict protocol ordering and we can bind that thread to CPU0 to take
# advantage of CPU affinity. When net.isr.maxthreads="-1" each thread will be
# bound to its own CPU core. Use "netstat -Q" to check bindings and
# workstreams. https://blog.cloudflare.com/how-to-receive-a-million-packets/
#
# Do Not enable net.isr.bindthreads on Chelsio T5/T4 cards.
#
net.isr.bindthreads="1"  # (default 0, runs randomly on any one cpu core)

# PF: Increase the size of the pf(4) source nodes hashtable from 32k to 1M. As
# the amount of remote source addresses starts to reach 100K, Pf will begin to
# be the limiting factor with regards to packet throughput on the network
# interfaces. By increasing the hashtable to 1M, Pf can sustain upwards of 80%
# of the maximum packets per second throughput with more than a million source
# addresses. Also set "src-nodes 1000000" in /etc/pf.conf . The hashtable
# increase is necessary for HTTP/3 UDP traffic due to the sheer number of
# malicious UDP packets creating states.
# https://www.bsdcan.org/2016/schedule/attachments/365_Improving%20PF
#
net.pf.source_nodes_hashsize="1048576"  # (default 32768)

###
######
######### OFF BELOW HERE #########
#
# Other options not used, but included for future reference.

# Disable UDP/IPv4 and UDP/IPv6 checksum offloading to network card
#
#hw.hn.enable_udp4cs="0"  # (default 1, enabled)
#hw.hn.enable_udp6cs="0"  # (default 1, enabled)
#hw.hn.trust_hostudp="0"  # (default 1, enabled)

# H-TCP Congestion Control for a more aggressive increase in sending speed on
# higher latency, high bandwidth networks with minimal packet loss.
#
#cc_htcp_load="YES"

# RACK TCP Stack: Netflix's TCP Recent ACKnowledgment (Recent ACK) and Tail
# Loss Probe (TLP) for improved Retransmit TimeOut response.
#
#tcp_rack_load="YES"

# CUBIC Congestion Control improves TCP-friendliness and RTT-fairness. The
# window growth function of CUBIC is governed by a cubic function in terms of
# the elapsed time since the last loss event.
# https://labs.ripe.net/Members/gih/bbr-tcp
#cc_cubic_load="YES"

# CAIA Delay-Gradient (CDG) is a temporal, delay-based TCP congestion control
#
#cc_cdg_load="YES"

# Maximum Send Queue Length: common recommendations are to set the interface
# buffer size to the number of packets the interface can transmit (send) in 50
# milliseconds _OR_ 256 packets times the number of interfaces in the machine;
# whichever value is greater. To calculate a size of a 50 millisecond buffer
# for a 60 megabit network take the bandwidth in megabits divided by 8 bits
# divided by the MTU times 50 millisecond times 1000, 60/8/1460*50*1000=256.84
# packets in 50 milliseconds. OR, if the box has two(2) interfaces take 256
# packets times two(2) NICs to equal 512 packets.  512 is greater then 256.84
# so set to 512.
#
# Our preference, if and only if you regularly reach your maximum upload
# bandwidth, is to define the interface queue length as two(2) times the value
# set in the interface transmit descriptor ring, "hw.igb.txd". If
# hw.igb.txd="1024" then set the net.link.ifqmaxlen="2048".
#
# An indirect result of increasing the interface queue is the buffer acts like
# a large TCP initial congestion window (init_cwnd) by allowing a network stack
# to burst packets at the start of a connection. Do not to set to zero(0) or
# the network will stop working due to "no network buffers" available. Do not
# set the interface buffer ludicrously large to avoid buffer bloat.
#net.link.ifqmaxlen="2048"  # (default 50)

# accf accept filters are used so the server will not have to context switch
# several times before performing the initial parsing of the request. This
# could decrease server load by reducing the amount of CPU time to handle
# incoming requests.  buffer incoming connections until complete HTTP requests
# arrive (nginx apache) for nginx http add, "listen 127.0.0.1:80
# accept_filter=httpready;"
#accf_http_load="YES"

# A FreeBSD accept_data filter can be used to protect https HTTP/2 (TLS) web
# servers, proxies, and accelerators. When a remote client connects to an Nginx
# https (TCP port 443) service the FreeBSD network stack negotiates the TCP
# connection. Without an accept_filter, the Nginx daemon immediately accept()'s
# the connection and will process the client data stream no matter how small or
# slow the transfer is. This means Nginx will waste resources on clients who
# never send any requests, send partial requests, immediately disconnect or
# time out. With an accept_filter, the FreeBSD kernel still does the TCP
# handshake but now the accept_filter will wait for the remote client to send a
# full request before ever notifying the nginx deamon of the new connection.
# The result is the Nginx deamon can focus on serving active client connections
# using its resources more efficiently. The accept_filter does not affect the
# latency or speed of client requests to Nginx because the Nginx daemon is
# notified of a complete client request at the same time as not using a filter.
# For nginx https servers add "listen 127.0.0.1:443 ssl http2
# accept_filter=dataready;" to the nginx.conf .
# https://savagedlight.me/2015/08/23/eli5-freebsd-accept-filters/
#accf_data_load="YES"

# Asynchronous I/O, or non-blocking I/O is a form of input/output processing
# permitting other processing to continue before the transmission has finished.
# AIO is used for accelerating Nginx on ZFS. Check for our tutorials on both.
# FreeBSD 11.0 removed the aio kernel module
#aio_load="YES"

# qlimit for igmp, arp, ether and ip6 queues only (netstat -Q) (default 256)
#net.isr.defaultqlimit="2048" # (default 256)

# enable /dev/crypto for IPSEC of custom seeding using the AES-NI Intel
# hardware cpu support
#aesni_load="YES"

# load the Intel PRO/1000 PCI Express kernel module on boot
#if_em_load="YES"

# load the Myri10GE kernel module on boot
#if_mxge_load="YES"

# load the Chelsio T520 (cxl) kernel module on boot
#t5fw_cfg_load="YES"
#if_cxgbe_load="YES"

# load the PF CARP module
#if_carp_load="YES"

# Wait for full DNS request accept filter (unbound)
#accf_dns_load="YES"

# Advanced Host Controller Interface (AHCI)
