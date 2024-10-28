https://calomel.org/freebsd_network_tuning.html

## Home or Office server (close to silent)

Processor    : Intel Core i7-6700 Skylake @ 3.40GHz , 65 watt
CPU Cooler   : Noctua NH-D9L Dual Tower CPU Cooler
Motherboard  : Asus Z270-A LGA 1151
Memory       : Kingston HyperX FURY DDR4 32GB 2133MHz (HX421C14FBK4/32)
Video        : Intel HD Graphics 530 integrated graphics on CPU 
Hard Drive   : Samsung 960 EVO Series, 1TB PCIe NVMe, M.2 Internal SSD (MZ-V6E1T0BW)
               HGST Ultrastar He10 HUH721010ALE604 10TB, two(2) drives, ZFS RAID1 mirror
Power Supply : EVGA SuperNOVA 650 P2, 80+ PLATINUM 650W
Case         : Corsair Carbide Series Air 540 with Arctic F12 PWM PST Fans
Network Card : Chelsio T520-BT, Dual port RJ-45 / 10GBase-T, 20 watts (PCIe 3 x8)
                -OR-
               Intel I350-T2 Server Adapter, 4.4 watts (PCIe v2.1 x4)

NOTE: Though we prefer Chelsio on FreeBSD, the Intel I350-T2 is an affordable,
      fast and stable line rate NIC which uses the FreeBSD igb(4) driver.



## Rack mounted server

Processor    : Intel(R) Xeon(R) CPU E5-2650 v4 @ 2.20GHz 95 Watt, 12 Core
Motherboard  : SMC, Intel C612 chipset
Memory       : 128 GB, DDR4-2400MHz, registered ECC memory w/ Thermal Sensor
Chassis      : SMC, 2U, 24 bay (2.5") with SAS3 expander backplane
Controller   : LSI MegaRAID SAS3 9300-4i4e, 12 Gigabit/sec HBA
Hard Drive   : 24x Mushkin MKNSSDRE1TB Reactor 1TB SSDs, mirrored ZFS root, LZ4 compression

Network Card : Chelsio T520-CR, 10GBASE-SR, LC Duplex (PCI Express x8)
Transceiver  : Chelsio SFP+ 10Gbit, SM10G-SR (850nm wavelength)
 -OR-
Network Card : Myricom Myri-10G 10G-PCIE2-8B2-2S (PCI Express x8)
Transceiver  : Myricom Myri-10G SFP+ 10GBase-SR optical fiber (850nm wavelength)

Switches     : Arista 7150S-52    ##  Both switches were able to saturate 
             : Force10 S4810      ##  a bidirectional 10gig interface