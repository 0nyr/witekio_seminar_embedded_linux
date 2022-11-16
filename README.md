# Witekio Seminary - Linux and embedded systems

> 2022/11/14

> iMX6 Sabre Lite card - Witekio 2450

## Build Linux from scratch

Follow the instruction of parts 1 up to part 3.

## Add additional package nInvaders

All files to modify and add are in `buildroot/`.

## Copy linux image to SD card

The teacher provided SD card readers in USB-C that cannot be plugged to laproom PCs. So the good idea is to use your own laptop or the one of a friend that have a micro-SD card reader.

1. Once the Linux image is built in `buildroot-2022.02.6/output/images/sdcard.img`, copy it (it's only 62,9Mb) to a USB stick.
2. Use a laptop with Micro SD reader. Plug the SD card from the iMX6 Sabre Lite card into the reader of your laptop.
3. The SD card is mounted automatically on your Linux. Go to super user: `sudo su`. The card is plugged, so it must be listed in `/dev/`.

```shell
root@kenzae:/dev# ll
brw-rw----   1 root disk      179,   0 nov.  14 17:25 mmcblk0
brw-rw----   1 root disk      179,   1 nov.  14 17:25 mmcblk0p1
```

Here, `mmcblk0` is the name of the SD card. And `mmcblk0p1` is the name of the first partition on the SD card.
You can check messages with `dmesg` to deduce the name of your SD card.

```shell
[20971.902307] mmc0: new high speed SDHC card at address 1234
[20971.902597] mmcblk0: mmc0:1234 SA04G 3.69 GiB 
[20971.908040]  mmcblk0: p1
[20973.950689] EXT4-fs (mmcblk0p1): recovery complete
[20973.955503] EXT4-fs (mmcblk0p1): mounted filesystem with ordered data mode. Opts: (null)
[20973.955515] ext4 filesystem being mounted at /media/onyr/0d7e49b7-a8f5-4fba-a9b3-a15e6f04b06e supports timestamps until 2038 (0x7fffffff)
```

4. See where the SD card is mounted with `mount | grep <sd_card_name>`

```shell
root@kenzae:/dev# mount | grep mmcb
/dev/mmcblk0p1 on /media/onyr/0d7e49b7-a8f5-4fba-a9b3-a15e6f04b06e type ext4 (rw,nosuid,nodev,relatime,errors=remount-ro,uhelper=udisks2)
```

5. To be able to copy the image to the SD Card, you need to umount the SD card partition. `umount <sd_partition>

```shell
root@kenzae:/dev# umount /dev/mmcblk0p1
```

After that, check that the partition is not mounted any more.

```shell
`mount | grep <sd_card_name>`
```

It's not because the card is not mounted that it disappeared from /dev/.

```shell
root@kenzae:/dev# ll | grep mm
brw-rw----   1 root disk      179,   0 nov.  14 17:29 mmcblk0
brw-rw----   1 root disk      179,   1 nov.  14 17:29 mmcblk0p1
```
6. Overwritte the partition on the SD card and copy the image to it with the following command: `dd if=/path/to/sdcard.img of=/dev/<sd_card_device> bs=1M`. WARNING !!! MAKE 100% SURE THE PARTITION YOU ARE GOING TO OVERWRITTE IS NOT YOUR COMPUTER PARTITION OR ANYTHING ELSE THAN THE SD CARD ! ELSE... RIP

```shell
root@kenzae:/dev# dd if=/home/onyr/Documents/5if/s1/seminaire_witekio_linux/sdcard.img of=/dev/mmcblk0 bs=1M
60+1 records in
60+1 records out
62915072 bytes (63 MB, 60 MiB) copied, 10,2267 s, 6,2 MB/s
```

7. Resync the filesystem: `sync`
8. Mount the overwritten partition of the SD Card to the laptop filesystem: `mount /dev/<sd_card_partition> /mnt/`

```shell
root@kenzae:/dev# mount /dev/mmcblk0p1 /mnt/
```

9. You can check the linux image has been correctly installed (flashed) to the mount point, here `/mnt` that should contain the files.

```shell
root@kenzae:/dev# cd /mnt/
bin/               lib32/             opt/               sys/               var/
boot/              linuxrc            proc/              tmp/             
dev/               lost+found/        root/              u-boot.nitrogen6q  
etc/               media/             run/               upgrade.scr      
lib/               mnt/               sbin/              usr/  
```

We can see after the SD card partition has been mounted, that the mount point contains linux dirs such as `root/`.
10. Don't forget to `umount /mnt/` before removing the SD card from the reader.


## Part 3

Copy and check the MBR of the SD card.

```shell
/dev/mmcblk0p1 on /media/onyr/rootfs type ext4 (rw,nosuid,nodev,relatime,uhelper=udisks2)
root@kenzae:/dev# hexdump -C /dev/mmcblk0 -n 512
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001c0  02 00 83 45 05 41 01 00  00 00 00 00 10 00 00 00  |...E.A..........|
000001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  |..............U.|
00000200
root@kenzae:/dev# dd if=/dev/mmcblk0 of=/home/onyr/DoMBR.bak count=1 bs=512 
Documents/ Downloads/ 
root@kenzae:/dev# dd if=/dev/mmcblk0 of=/home/onyr/DoMBR.bak count=1 bs=512 
Documents/ Downloads/ 
root@kenzae:/dev# dd if=/dev/mmcblk0 of=/home/onyr/Documents/5if/s1/sMBR.bak count=1 bs=512 
seminaire_sopra_steria/  seminaire_witekio_linux/ shs/                 
root@kenzae:/dev# dd if=/dev/mmcblk0 of=/home/onyr/Documents/5if/s1/seminaire_witekio_linux/MBR.bak count=1 bs=512 
1+0 records in
1+0 records out
512 bytes copied, 0,000836951 s, 612 kB/s
root@kenzae:/dev# hexdump -C /home/onyr/Documents/5if/s1/seminaire_witekio_linux/MBR.bak
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001c0  02 00 83 45 05 41 01 00  00 00 00 00 10 00 00 00  |...E.A..........|
000001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  |..............U.|
00000200
```

Overwritte the MBR with zeros

```shell
root@kenzae:/dev# dd if=/dev/zero of=/dev/mmcblk0 count=1 bs=512 
1+0 records in
1+0 records out
512 bytes copied, 0,000344892 s, 1,5 MB/s
root@kenzae:/dev# hexdump -C /dev/mmcblk0 -n 512
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200
root@kenzae:/dev# ll | grep mmcblk0
brw-rw----   1 root disk      179,   0 nov.  16 10:37 mmcblk0
brw-rw----   1 root disk      179,   1 nov.  16 10:37 mmcblk0p1
root@kenzae:/dev# hexdump -C /dev/mmcblk0p1 -n 512
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200

```

Create a partition in the MBR that has all space on the SD Card.

```shell
root@kenzae:/dev# ll | grep mmcblk0
brw-rw----   1 root disk      179,   0 nov.  16 10:37 mmcblk0
brw-rw----   1 root disk      179,   1 nov.  16 10:37 mmcblk0p1
root@kenzae:/dev# hexdump -C /dev/mmcblk0p1 -n 512
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200
root@kenzae:/dev# parted /dev/mmcblk0 mklabel msdos
Error: Partition(s) 1 on /dev/mmcblk0 have been written, but we have been unable to inform the kernel
of the change, probably because it/they are in use.  As a result, the old partition(s) will remain in
use.  You should reboot now before making further changes.
Ignore/Cancel? ignore                                           
Information: You may need to update /etc/fstab.

root@kenzae:/dev# parted -a optimal /dev/mmcblk0 mkpart primary 0% 100%
Error: Partition(s) 1 on /dev/mmcblk0 have been written, but we have been unable to inform the kernel
of the change, probably because it/they are in use.  As a result, the old partition(s) will remain in
use.  You should reboot now before making further changes.
Ignore/Cancel? ignore                                           
Information: You may need to update /etc/fstab.

root@kenzae:/dev# hexdump -C /dev/mmcblk0p1 -n 512   
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200
root@kenzae:/dev# hexdump -C /dev/mmcblk -n 512
hexdump: /dev/mmcblk: No such file or directory
root@kenzae:/dev# hexdump -C /dev/mmcblk0 -n 512
00000000  fa b8 00 10 8e d0 bc 00  b0 b8 00 00 8e d8 8e c0  |................|
00000010  fb be 00 7c bf 00 06 b9  00 02 f3 a4 ea 21 06 00  |...|.........!..|
00000020  00 be be 07 38 04 75 0b  83 c6 10 81 fe fe 07 75  |....8.u........u|
00000030  f3 eb 16 b4 02 b0 01 bb  00 7c b2 80 8a 74 01 8b  |.........|...t..|
00000040  4c 02 cd 13 ea 00 7c 00  00 eb fe 00 00 00 00 00  |L.....|.........|
00000050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001b0  00 00 00 00 00 00 00 00  8d 3e 4b 24 00 00 00 04  |.........>K$....|
000001c0  01 04 83 fe c2 ff 00 08  00 00 00 f8 75 00 00 00  |............u...|
000001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  |..............U.|
00000200
root@kenzae:/dev# hexdump -C /dev/mmcblk0 -n 512
mmcblk0    mmcblk0p1  
root@kenzae:/dev# hexdump -C /dev/mmcblk0p1 -n 512
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200

```

# Part 4 Witekio

0. Plus the SabreLite card via serial bus... unpowered!
1. Go `sudo su`
2. run `picocom -b 115200 /dev/ttyUSB0 `. NOTE: There should be only one `/dev/ttyUSB`.
3. Power in the plugged SabreLite
4. You should see many logs as the kernel and OS start.
```shell
formation@formation-virtual-machine:~$ sudo su
[sudo] password for formation: 
root@formation-virtual-machine:/home/formation# picocom -b 115200 /dev/ttyUSB0 
picocom v3.1

port is        : /dev/ttyUSB0
flowcontrol    : none
baudrate is    : 115200
parity is      : none
databits are   : 8
stopbits are   : 1
escape is      : C-a
local echo is  : no
noinit is      : no
noreset is     : no
hangup is      : no
nolock is      : no
send_cmd is    : sz -vv
receive_cmd is : rz -vv -E
imap is        : 
omap is        : 
emap is        : crcrlf,delbs,
logfile is     : none
initstring     : none
exit_after is  : not set
exit is        : no

Type [C-a] [C-h] to see available commands
Terminal ready


U-Boot 2020.10 (Oct 17 2022 - 11:50:30 +0200)

CPU:   i.MX6Q rev1.2 at 792 MHz
Reset cause: POR
Model: Boundary Devices i.MX6 Quad Nitrogen6x Board
Board: sabrelite
I2C:   ready
DRAM:  1 GiB
MMC:   FSL_SDHC: 0, FSL_SDHC: 1
Loading Environment from SPIFlash...
SF: Detected sst25vf016b with page size 256 Bytes, erase size 4 KiB, total 2 MiB
OK
Display: hdmi:1280x720M@60 (1280x720)
In:    serial
Out:   serial
Err:   serial
Net:   Micrel ksz9021 at 6
FEC [PRIME]
Error: FEC address not set.
, usb_ether
Hit any key to stop autoboot:  0 
MMC: no card present
mmc_init: -123, time 1
switch to partitions #0, OK
mmc1 is current device
Scanning mmc 1:1...
Found U-Boot script /boot/boot.scr
4554 bytes read in 20 ms (221.7 KiB/s)
## Executing script at 10008000
cpu2=6Q
cpu3=6Q
Failed to load 'uEnv.txt'
53719 bytes read in 23 ms (2.2 MiB/s)
6778712 bytes read in 501 ms (12.9 MiB/s)
Kernel image @ 0x10800000 [ 0x000000 - 0x676f58 ]
## Flattened Device Tree blob at 13000000
   Booting using the fdt blob at 0x13000000
   Using Device Tree in place at 13000000, end 13014fff

Starting kernel ...

Booting Linux on physical CPU 0x0
Linux version 5.10.63 (formation@formation-virtual-machine) (arm-buildroot-linux-gnueabihf-gcc.br_real (Buildroot 2022.02.6) 10.4.0, GNU ld (GNU Binutils) 2.36.1) #1 SMP PREEMPT Mon Nov 14 15:58:44 CET 2022
CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=10c5387d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
OF: fdt: Machine model: Freescale i.MX6 Quad SABRE Lite Board
Memory policy: Data cache writealloc
Reserved memory: created CMA memory pool at 0x3c000000, size 320 MiB
OF: reserved mem: initialized node linux,cma, compatible id shared-dma-pool
Zone ranges:
  Normal   [mem 0x0000000010000000-0x000000004fffffff]
  HighMem  empty
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x0000000010000000-0x000000004fffffff]
Initmem setup node 0 [mem 0x0000000010000000-0x000000004fffffff]
percpu: Embedded 16 pages/cpu s32844 r8192 d24500 u65536
Built 1 zonelists, mobility grouping on.  Total pages: 259840
Kernel command line: console=ttymxc1,115200 vmalloc=400M consoleblank=0 rootwait fixrtc cpu=6Q board=sabrelite uboot_release=2020.10 root=/dev/mmcblk1p1
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes, linear)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes, linear)
mem auto-init: stack:off, heap alloc:off, heap free:off
Memory: 693796K/1048576K available (10240K kernel code, 1177K rwdata, 2596K rodata, 1024K init, 467K bss, 27100K reserved, 327680K cma-reserved, 0K highmem)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
rcu: Preemptible hierarchical RCU implementation.
rcu: 	RCU event tracing is enabled.
	Trampoline variant of Tasks RCU enabled.
rcu: RCU calculated value of scheduler-enlistment delay is 10 jiffies.
NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
L2C-310 errata 752271 769419 enabled
L2C-310 enabling early BRESP for Cortex-A9
L2C-310 full line of zeros enabled for Cortex-A9
L2C-310 ID prefetch enabled, offset 16 lines
L2C-310 dynamic clock gating enabled, standby mode enabled
L2C-310 cache controller enabled, 16 ways, 1024 kB
L2C-310: CACHE_ID 0x410000c7, AUX_CTRL 0x76470001
random: get_random_bytes called from start_kernel+0x324/0x4f0 with crng_init=0
Switching to timer-based delay loop, resolution 333ns
sched_clock: 32 bits at 3000kHz, resolution 333ns, wraps every 715827882841ns
clocksource: mxc_timer1: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 637086815595 ns
Console: colour dummy device 80x30
Calibrating delay loop (skipped), value calculated using timer frequency.. 6.00 BogoMIPS (lpj=30000)
pid_max: default: 32768 minimum: 301
LSM: Security Framework initializing
Yama: becoming mindful.
AppArmor: AppArmor initialized
Mount-cache hash table entries: 2048 (order: 1, 8192 bytes, linear)
Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes, linear)
CPU: Testing write buffer coherency: ok
CPU0: Spectre v2: using BPIALL workaround
CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
Setting up static identity map for 0x10100000 - 0x10100060
rcu: Hierarchical SRCU implementation.
smp: Bringing up secondary CPUs ...
CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
CPU1: Spectre v2: using BPIALL workaround
CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
CPU2: Spectre v2: using BPIALL workaround
CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
CPU3: Spectre v2: using BPIALL workaround
smp: Brought up 1 node, 4 CPUs
SMP: Total of 4 processors activated (24.00 BogoMIPS).
CPU: All CPU(s) started in SVC mode.
devtmpfs: initialized
VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 4
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
futex hash table entries: 1024 (order: 4, 65536 bytes, linear)
pinctrl core: initialized pinctrl subsystem
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
audit: initializing netlink subsys (disabled)
audit: type=2000 audit(0.030:1): state=initialized audit_enabled=0 res=1
thermal_sys: Registered thermal governor 'step_wise'
cpuidle: using governor menu
CPU identified as i.MX6Q, silicon rev 1.2
vdd1p1: supplied by regulator-dummy
vdd3p0: supplied by regulator-dummy
vdd2p5: supplied by regulator-dummy
vddarm: supplied by regulator-dummy
vddpu: supplied by regulator-dummy
vddsoc: supplied by regulator-dummy
mxs_phy 20c9000.usbphy: supply phy-3p0 not found, using dummy regulator
mxs_phy 20ca000.usbphy: supply phy-3p0 not found, using dummy regulator
hw-breakpoint: found 5 (+1 reserved) breakpoint and 1 watchpoint registers.
hw-breakpoint: maximum watchpoint size is 4 bytes.
imx6q-pinctrl 20e0000.pinctrl: initialized IMX pinctrl driver
imx mu driver is registered.
imx rpmsg driver is registered.
Kprobes globally optimized
2020000.serial: ttymxc0 at MMIO 0x2020000 (irq = 32, base_baud = 5000000) is a IMX
21e8000.serial: ttymxc1 at MMIO 0x21e8000 (irq = 79, base_baud = 5000000) is a IMX
printk: console [ttymxc1] enabled
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
usb_phy_generic usbphynop1: supply vcc not found, using dummy regulator
usb_phy_generic usbphynop2: supply vcc not found, using dummy regulator
imx-i2c 21a0000.i2c: stop-delay=0, inter-byte-delay=0
gpio-85 (scl): enforced open drain please flag it properly in DT/ACPI DSDT/board file
i2c i2c-0: IMX I2C adapter registered
imx-i2c 21a4000.i2c: stop-delay=0, inter-byte-delay=0
gpio-108 (scl): enforced open drain please flag it properly in DT/ACPI DSDT/board file
i2c i2c-1: IMX I2C adapter registered
imx-i2c 21a8000.i2c: stop-delay=0, inter-byte-delay=0
gpio-5 (scl): enforced open drain please flag it properly in DT/ACPI DSDT/board file
i2c i2c-2: IMX I2C adapter registered
mc: Linux media interface: v0.10
videodev: Linux video capture interface: v2.00
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
imx-ipuv3 2400000.ipu: IPU DMFC NORMAL mode: 1(0~1), 5B(4,5), 5F(6,7)
imx-ipuv3 2800000.ipu: IPU DMFC NORMAL mode: 1(0~1), 5B(4,5), 5F(6,7)
mxc_vdoa 21e4000.vdoa: i.MX Video Data Order Adapter(VDOA) driver probed
mxc_mipi_csi2 21dc000.mipi: i.MX MIPI CSI2 driver probed
mxc_mipi_csi2 21dc000.mipi: i.MX MIPI CSI2 dphy version is 0x3130302a
MIPI CSI2 driver module loaded
Advanced Linux Sound Architecture Driver Initialized.
Bluetooth: Core ver 2.22
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
NetLabel:  unlabeled traffic allowed by default
clocksource: Switched to clocksource mxc_timer1
VFS: Disk quotas dquot_6.6.0
VFS: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
AppArmor: AppArmor Filesystem Enabled
NET: Registered protocol family 2
IP idents hash table entries: 16384 (order: 5, 131072 bytes, linear)
tcp_listen_portaddr_hash hash table entries: 512 (order: 0, 6144 bytes, linear)
TCP established hash table entries: 8192 (order: 3, 32768 bytes, linear)
TCP bind hash table entries: 8192 (order: 4, 65536 bytes, linear)
TCP: Hash tables configured (established 8192 bind 8192)
UDP hash table entries: 512 (order: 2, 16384 bytes, linear)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes, linear)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
PCI: CLS 0 bytes, default 64
hw perfevents: no interrupt-affinity property for /pmu, guessing.
hw perfevents: enabled with armv7_cortex_a9 PMU driver, 7 counters available
Bus freq driver module loaded
Initialise system trusted keyrings
Key type blacklist registered
workingset: timestamp_bits=14 max_order=18 bucket_order=4
squashfs: version 4.0 (2009/01/31) Phillip Lougher
NFS: Registering the id_resolver key type
Key type id_resolver registered
Key type id_legacy registered
fuse: init (API version 7.32)
Key type asymmetric registered
Asymmetric key parser 'x509' registered
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 245)
io scheduler mq-deadline registered
io scheduler kyber registered
imx6q-pcie 1ffc000.pcie: supply epdev_on not found, using dummy regulator
ldb ldb: failed to find valid LVDS channel
imx6q-pcie 1ffc000.pcie: pcie_ext_src clk src missing or invalid
ldb: probe of ldb failed with error -22
imx6q-pcie 1ffc000.pcie: host bridge /soc/pcie@1ffc000 ranges:
mxc_hdmi 20e0000.hdmi_video: supply HDMI not found, using dummy regulator
imx6q-pcie 1ffc000.pcie:       IO 0x0001f80000..0x0001f8ffff -> 0x0000000000
mxc_hdmi 20e0000.hdmi_video: Detected HDMI controller 0x13:0xa:0xa0:0xc1
imx6q-pcie 1ffc000.pcie:      MEM 0x0001000000..0x0001efffff -> 0x0001000000
fbcvt: 1280x720@60: CVT Name - .921M9
mxc_sdc_fb fb@2: registered mxc display driver hdmi
mxc_sdc_fb fb@2: 1280x720 h_sync,r,l: 40,110,220  v_sync,l,u: 5,5,20 pixclock=74250000 Hz
imx-ipuv3 2800000.ipu: try ipu internal clk
imx-ipuv3 2800000.ipu: disp=0, pixel_clk=74250000 74250000 parent=74250000 div=1
find_field: [0] = 0x7ff, max=23
find_field: [1] = 0xfff, max=23
find_field: [2] = 0x17ff, max=23
find_field: [0] = 0x820, max=29
imx-ipuv3 2800000.ipu: IPU DMFC DP HIGH RESOLUTION: 1(0,1), 5B(2~5), 5F(6,7)
mxc_sdc_fb fb@2: 1280x720 h_sync,r,l: 40,110,220  v_sync,l,u: 5,5,20 pixclock=74250000 Hz
imx-ipuv3 2800000.ipu: try ipu internal clk
imx-ipuv3 2800000.ipu: disp=0, pixel_clk=74250000 74250000 parent=74250000 div=1
Console: switching to colour frame buffer device 160x45
add tfp410 i2c driver
imx-sdma 20ec000.sdma: firmware found.
imx-sdma 20ec000.sdma: loaded firmware 3.5
mxs-dma 110000.dma-apbh: initialized
imx sema4 driver is registered.
brd: module loaded
loop: module loaded
[max77823_init] start 
ahci-imx 2200000.sata: fsl,transmit-level-mV not specified, using 00000024
ahci-imx 2200000.sata: fsl,transmit-boost-mdB not specified, using 00000480
ahci-imx 2200000.sata: fsl,transmit-atten-16ths not specified, using 00002000
ahci-imx 2200000.sata: fsl,receive-eq-mdB not specified, using 05000000
ahci-imx 2200000.sata: supply ahci not found, using dummy regulator
ahci-imx 2200000.sata: supply phy not found, using dummy regulator
ahci-imx 2200000.sata: supply target not found, using dummy regulator
ahci-imx 2200000.sata: SSS flag set, parallel bus scan disabled
ahci-imx 2200000.sata: AHCI 0001.0300 32 slots 1 ports 3 Gbps 0x1 impl platform mode
ahci-imx 2200000.sata: flags: ncq sntf stag pm led clo only pmp pio slum part ccc apst 
scsi host0: ahci-imx
ata1: SATA max UDMA/133 mmio [mem 0x02200000-0x02203fff] port 0x100 irq 86
imx ahci driver is registered.
spi-nor spi0.0: sst25vf016b (2048 Kbytes)
3 fixed-partitions partitions found on MTD device spi0.0
Creating 3 MTD partitions on "spi0.0":
0x000000000000-0x0000000c0000 : "bootloader"
0x0000000c0000-0x0000000c2000 : "env"
0x0000000c2000-0x000000200000 : "splash"
libphy: Fixed MDIO Bus: probed
CAN device driver interface
pps pps0: new PPS source ptp0
fec 2188000.ethernet: Invalid MAC address: 00:00:00:00:00:00
fec 2188000.ethernet: Using random MAC address: 52:08:12:9d:ad:88
libphy: fec_enet_mii_bus: probed
mdio_bus 2188000.ethernet-1: ethernet-phy has invalid PHY address
fec 2188000.ethernet eth0: registered PHC device 0
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
usbcore: registered new interface driver cdc_acm
cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usb-storage
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial support registered for generic
usbcore: registered new interface driver cp210x
usbserial: USB Serial support registered for cp210x
usbcore: registered new interface driver ftdi_sio
usbserial: USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver keyspan
usbserial: USB Serial support registered for Keyspan - (without firmware)
usbserial: USB Serial support registered for Keyspan 1 port adapter
usbserial: USB Serial support registered for Keyspan 2 port adapter
usbserial: USB Serial support registered for Keyspan 4 port adapter
usbcore: registered new interface driver pl2303
usbserial: USB Serial support registered for pl2303
usbcore: registered new interface driver qcserial
usbserial: USB Serial support registered for Qualcomm USB modem
setup_reset_gpios:-2, flags 0
setup_reset_gpios:204, flags 1
setup_reset_gpios:-2, flags 1
i2c /dev entries driver
mxc_v4l2_output v4l2-out: V4L2 device registered as video16
mxc_v4l2_output v4l2-out: V4L2 device registered as video17
check_alarm_past: alarm in the past
snvs_rtc 20cc000.snvs:snvs-rtc-lp: registered as rtc0
snvs_rtc 20cc000.snvs:snvs-rtc-lp: setting system clock to 1970-01-01T00:00:00 UTC (0)
device-mapper: ioctl: 4.43.0-ioctl (2020-10-01) initialised: dm-devel@redhat.com
Bluetooth: HCI UART driver ver 2.3
Bluetooth: HCI UART protocol H4 registered
Bluetooth: HCI UART protocol LL registered
Bluetooth: HCI UART protocol QCA registered
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pltfm: SDHCI platform and OF driver helper
sdhci-esdhc-imx 2198000.mmc: voltage-ranges unspecified
sdhci-esdhc-imx 219c000.mmc: voltage-ranges unspecified
caam 2100000.crypto: Entropy delay = 3200
sdhci-esdhc-imx 2198000.mmc: Got CD GPIO
sdhci-esdhc-imx 219c000.mmc: Got CD GPIO
caam 2100000.crypto: Instantiated RNG4 SH0
sdhci-esdhc-imx 2198000.mmc: Got WP GPIO
caam 2100000.crypto: Instantiated RNG4 SH1
ata1: SATA link down (SStatus 0 SControl 300)
ahci-imx 2200000.sata: no device found, disabling link.
ahci-imx 2200000.sata: pass ahci_imx..hotplug=1 to enable hotplug
caam 2100000.crypto: device ID = 0x0a16010000000000 (Era 4)
caam 2100000.crypto: job rings = 2, qi = 0
mmc0: SDHCI controller on 2198000.mmc [2198000.mmc] using ADMA
mmc1: SDHCI controller on 219c000.mmc [219c000.mmc] using ADMA
caam algorithms registered in /proc/crypto
caam 2100000.crypto: registering rng-caam
Device caam-keygen registered
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
mxc_vpu 2040000.vpu_fsl: VPU initialized
mmc1: host does not support reading read-only switch, assuming write-enable
sgtl5000 0-000a: sgtl5000 revision 0x11
mmc1: new high speed SDHC card at address 1234
sgtl5000 0-000a: Using internal LDO instead of VDDD: check ER1 erratum
mmcblk1: mmc1:1234 SA04G 3.69 GiB 
 mmcblk1: p1
random: fast init done
fsl-ssi-dai 2028000.ssi: No cache defaults, reading back from HW
random: crng init done
fsl-ssi-dai 202c000.ssi: No cache defaults, reading back from HW
NET: Registered protocol family 26
NET: Registered protocol family 10
Segment Routing with IPv6
sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
NET: Registered protocol family 17
can: controller area network core
NET: Registered protocol family 29
can: raw protocol
can: broadcast manager protocol
can: netlink gateway - max_hops=1
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
8021q: 802.1Q VLAN Support v1.8
Key type dns_resolver registered
cpu cpu0: Empty OPP table
cpu cpu0: OPP table empty
cpu cpu0: _allocate_opp_table: Error finding interconnect paths: -22
Registering SWP/SWPB emulation handler
Loading compiled-in X.509 certificates
Key type encrypted registered
AppArmor: AppArmor sha1 policy hashing enabled
setup_reset_gpios:-2, flags 0
imx_usb 2184000.usb: No over current polarity defined
imx6q-pcie 1ffc000.pcie: Phy link never came up
imx6q-pcie 1ffc000.pcie: failed to initialize host
imx6q-pcie 1ffc000.pcie: unable to add pcie port.
setup_reset_gpios:204, flags 1
setup_reset_gpios:-2, flags 1
ci_hdrc ci_hdrc.1: EHCI Host Controller
ci_hdrc ci_hdrc.1: new USB bus registered, assigned bus number 1
ci_hdrc ci_hdrc.1: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 1 port detected
imx_thermal 20c8000.anatop:tempmon: Automotive CPU temperature grade - max:125C critical:120C passive:115C
ALSA device list:
  #0: sgtl5000-audio
EXT4-fs (mmcblk1p1): INFO: recovery required on readonly filesystem
EXT4-fs (mmcblk1p1): write access will be enabled during recovery
usb 1-1: new high-speed USB device number 2 using ci_hdrc
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 3 ports detected
EXT4-fs (mmcblk1p1): recovery complete
EXT4-fs (mmcblk1p1): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 179:1.
devtmpfs: mounted
Freeing unused kernel memory: 1024K
Run /sbin/init as init process
EXT4-fs (mmcblk1p1): re-mounted. Opts: (null)
Starting syslogd: OK
Starting klogd: OK
Running sysctl: OK
Initializing random number generator: OK
Saving random seed: OK
Starting network: OK
Starting dropbear sshd: OK

Welcome to Buildroot
buildroot login: root
# usb_otg_vbus: disabling
whoami
root
# pwd
/root
# 
```

### Plug Ethernet
0. Unplug power of SabreLite. Restart nfs-kernel-server.service with systemctl. Then plug ethernet-USB to the development PC and replug power of SabreLite card. 
1. Use Ubuntu Network Manager GUI and put a manual IP Address, like 192.168.0.1 with 255.255.255.0 mask (only 0 zero since it is local network).
2. Use commands in the doc to stop boot and modify manually environment variables so as to boot from master development PC.

```shell
formation@formation-virtual-machine:~/Downloads/buildroot-2022.02.6$ sudo su
[sudo] password for formation: 
root@formation-virtual-machine:/home/formation/Downloads/buildroot-2022.02.6# picocom -b 115200 /dev/ttyUSB0 
picocom v3.1

port is        : /dev/ttyUSB0
flowcontrol    : none
baudrate is    : 115200
parity is      : none
databits are   : 8
stopbits are   : 1
escape is      : C-a
local echo is  : no
noinit is      : no
noreset is     : no
hangup is      : no
nolock is      : no
send_cmd is    : sz -vv
receive_cmd is : rz -vv -E
imap is        : 
omap is        : 
emap is        : crcrlf,delbs,
logfile is     : none
initstring     : none
exit_after is  : not set
exit is        : no

Type [C-a] [C-h] to see available commands
Terminal ready


U-Boot 2020.10 (Oct 17 2022 - 11:50:30 +0200)

CPU:   i.MX6Q rev1.2 at 792 MHz
Reset cause: POR
Model: Boundary Devices i.MX6 Quad Nitrogen6x Board
Board: sabrelite
I2C:   ready
DRAM:  1 GiB
MMC:   FSL_SDHC: 0, FSL_SDHC: 1
Loading Environment from SPIFlash...
SF: Detected sst25vf016b with page size 256 Bytes, erase size 4 KiB, total 2 MiB
OK
Display: hdmi:1280x720M@60 (1280x720)
In:    serial
Out:   serial
Err:   serial
Net:   Micrel ksz9021 at 6
FEC [PRIME]
Error: FEC address not set.
, usb_ether
Hit any key to stop autoboot:  0 
=> setenv ethaddr 4F:7F:66:D6:19:DA

Error: FEC address 4f:7f:66:d6:19:da illegal value
=> setenv ethaddr 00:0C:29:FD:B3:B7

Warning: FEC MAC addresses don't match:
Address in SROM is         00:0c:29:fd:b3:b7
Address in environment is  4f:7f:66:d6:19:da

Error: FEC address 4f:7f:66:d6:19:da illegal value
=> setenv ethaddr 22:33:44:55:66:66   
## Error: flags type check failure for "ethaddr" <= "22ype: m)
## Error inserting "ethaddr" variable, errno=1
Unknown command '2B:33:44:55:66:66' - try 'help'
exit                               
exit not allowed from main input shell.
=> setenv ethaddr 22:33:44:55:66:66

Warning: FEC MAC addresses don't match:
Address in SROM is         22:33:44:55:66:66
Address in environment is  00:0c:29:fd:b3:b7
=> setenv serverip 192.168.0.2
=> setenv netargs 'setenv bootargs console=${console},${baudrate} root=/dev/nfs ip=dhcp nfsroot=${serverip}:$[nfsroot},v3,tcp'
=> setenv nfsroot '/srv/nfs/rootfs'
=> setenv netboot 'dhcp ${loadaddr} zImage; tftp ${ftd_addr} imx6q-sabrelite.dtb; bootz ${loadaddr} -INTERRUPT>} imx6q-sabrelite.                                    
=> setenv netboot 'dhcp ${loadaddr} zImage; tftp${fdt_addr} imx6q-sabrelite.dtb; bootz ${loadaddr} - ${fdt_addr}'
=> setenv bootcmd 'run netargs; run netboot'
=> saveenv
Saving Environment to SPIFlash... SF: Detected sst25vf016b with page size 256 Bytes, erase size 4 KiB, total 2 MiB
Erasing SPI flash...Writing to SPI flash...done
OK
=> boog
Unknown command 'boog' - try 'help'
=> boot
BOOTP broadcast 1
BOOTP broadcast 2
BOOTP broadcast 3
BOOTP broadcast 4
BOOTP broadcast 5
BOOTP broadcast 6
BOOTP broadcast 7
BOOTP broadcast 8
BOOTP broadcast 9
BOOTP broadcast 10
BOOTP broadcast 11
BOOTP broadcast 12
BOOTP broadcast 13
BOOTP broadcast 14
BOOTP broadcast 15
BOOTP broadcast 16
BOOTP broadcast 17

Retry time exceeded; starting again
Unknown command 'tftp13000000' - try 'help'
zimage: Bad magic!
=> setenv serverip 192.168.0.1
=> saveenv
Saving Environment to SPIFlash... Erasing SPI flash...Writing to SPI flash...done
OK
=> boot
BOOTP broadcast 1
BOOTP broadcast 2
BOOTP broadcast 3
BOOTP broadcast 4
BOOTP broadcast 5
BOOTP broadcast 6
BOOTP broadcast 7
BOOTP broadcast 8
BOOTP broadcast 9

Abort
Unknown command 'tftp13000000' - try 'help'
zimage: Bad magic!
=> setenv ipaddr 192.168.0.2
=> setenv netargs 'setenv bootargs console=${console},${baudrate} root=/dev/nfs ip=${ipaddr} nfsroot=${serverip}:$[nfsroot},v3,tcp'
=> setenv netboot 'tftp ${loadaddr} zImage; tftp ${fdt_addr} imx6q-sabrelite.dtb; bootz ${loadaddr} - ${fdt_addr}'                 
=> saveenv
Saving Environment to SPIFlash... Erasing SPI flash...Writing to SPI flash...done
OK
=> boot
Using FEC device
TFTP from server 192.168.0.1; our IP address is 192.168.0.2
```

If the manual setup is working, the config is saved. So don't worry to restart the board if needed. You should see something like that:
```shell
Hit any key to stop autoboot:  0 
FEC Waiting for PHY auto negotiation to complete. done
Using FEC device
TFTP from server 192.168.0.1; our IP address is 192.168.0.2
```
If you get a kernel panic, it's very probably because of a typo in the commands you entered while manually setting the boot env vars. Use the reboot button and press a key to correct the bad config.

## Change config with an overlay dir
1. Create an `overlay/` inside the Buildroot directory.
2. Read the commands and instructions to modify the hostname, password and specify a script.
3. Don't forget to copy the result (tarball) of the `make` command to the `rootfs` server: `sudo tar xvf output/images/rootfs.tar.bz2 -C /srv/nfs/rootfs/`.
4. Restart the board with the reset green button.
5. You should see several IP addresses.
```shell
Welcome to Buildroot
buildroot_nounours login: root
Password: 
# whoami
root
# ifconfig 
eth0      Link encap:Ethernet  HWaddr 22:33:44:55:66:66  
          inet addr:192.168.0.2  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::2033:44ff:fe55:6666/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:2732 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1860 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:3241550 (3.0 MiB)  TX bytes:288644 (281.8 KiB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

# usb_otg_vbus: disabling
# cat /etc/network/interfaces 
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
	address 192.168.0.69
	netmask 255.255.255.0
	gateway 192.168.0.1



# sys
sysctl   syslogd
# sys
sysctl   syslogd
# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: can0: <NOARP40000> mtu 16 qdisc noop qlen 10
    link/[280] 
3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 22:33:44:55:66:66 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.2/24 brd 192.168.0.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet 192.168.0.69/24 scope global secondary eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::2033:44ff:fe55:6666/64 scope link 
       valid_lft forever preferred_lft forever
4: sit0@NONE: <NOARP> mtu 1480 qdisc noop qlen 1000
    link/sit 0.0.0.0 brd 0.0.0.0
```

Run the commands to cross-compile linux. Then `cp` inside `arch/arm/boot` to copy zImage inside `/srv/nfs/rootfs/`. Also `cp` `dts/imx6q-sabrelite.dtb` and `zImage` into `/srv/tftp/`.
```shell
formation@formation-virtual-machine:~/Downloads/linux/arch/arm/boot$ sudo cp zImage /srv/tftp/
formation@formation-virtual-machine:~/Downloads/linux/arch/arm/boot$ sudo cp dts/
Display all 2413 possibilities? (y or n)
formation@formation-virtual-machine:~/Downloads/linux/arch/arm/boot$ sudo cp dts/imx
Display all 715 possibilities? (y or n)
formation@formation-virtual-machine:~/Downloads/linux/arch/arm/boot$ sudo cp dts/imx6q-
Display all 156 possibilities? (y or n)
formation@formation-virtual-machine:~/Downloads/linux/arch/arm/boot$ sudo cp dts/imx6q-sabrelite.dtb /srv/tftp/
```


## Part 8

1. Find logo
```shell
formation@formation-virtual-machine:~/Downloads/linux$ find -name logo
./drivers/video/logo
./include/config/logo
```
2. Find MVNETA maintainer.
```shell
formation@formation-virtual-machine:~/Downloads/linux/drivers$ find -name *mvneta*
./net/ethernet/marvell/mvneta.c
./net/ethernet/marvell/mvneta_bm.c
./net/ethernet/marvell/mvneta_bm.h
```
Inside the file, we get the maintainers in comments:
```shell
 * Rami Rosen <rosenr@marvell.com>
 * Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
```
3. Got to `https://elexir.bootlin.com/linux`. Get the downloaded linux version from the Makefile.
```shell
# SPDX-License-Identifier: GPL-2.0
VERSION = 5
PATCHLEVEL = 10
SUBLEVEL = 104
```
Here we have linux v5.10.104 then find it on the website. Search the function `platform_device_register`. You get all the different files containing the function. We found it inside `drivers/base/platform.c`.
```shell
formation@formation-virtual-machine:~/Downloads/linux/drivers$ git grep platform_device_register
[...]
base/platform.c:                ret = platform_device_register(devs[i]);
base/platform.c: * This is part 2 of platform_device_register(), though may be called
base/platform.c: * platform_device_register - add a platform-level device
base/platform.c:int platform_device_register(struct platform_device *pdev)
base/platform.c:EXPORT_SYMBOL_GPL(platform_device_register);
base/platform.c: * platform_device_register_full - add a platform-level device with
base/platform.c:struct platform_device *platform_device_register_full(
base/platform.c:EXPORT_SYMBOL_GPL(platform_device_register_full);
[...]
```








 




















## miscellaneous

```shell
root@kenzae:/dev# parted /dev/mmcblk0p1 mklabel msdos
Warning: The existing disk label on /dev/mmcblk0p1 will be destroyed and all data on this disk will
be lost. Do you want to continue?
Yes/No? yes                                                             
Error: Partition(s) 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64 on /dev/mmcblk0p1 have been
written, but we have been unable to inform the kernel of the change, probably because it/they are in
use.  As a result, the old partition(s) will remain in use.  You should reboot now before making
further changes.
Ignore/Cancel? Ignore
Information: You may need to update /etc/fstab.

root@kenzae:/dev# sudo parted -a optimal /dev/mmcblk0p1 
Display all 277 possibilities? (y or n)
root@kenzae:/dev# parted -a optimal /dev/mmcblk0p1 mkpart primary 0% 100%
Error: Partition(s) 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64 on /dev/mmcblk0p1 have been
written, but we have been unable to inform the kernel of the change, probably because it/they are in
use.  As a result, the old partition(s) will remain in use.  You should reboot now before making
further changes.
Ignore/Cancel? Ignore                                                   
Information: You may need to update /etc/fstab.

root@kenzae:/dev# sudo dd if=/home/onyr/Documents/5if/s1/s
seminaire_sopra_steria/  seminaire_witekio_linux/ shs/                   
root@kenzae:/dev# sudo dd if=/home/onyr/Documents/5if/s1/seminaire_witekio_linux/
linux-for-schools-labs.pdf  sdcard.img                
root@kenzae:/dev# dd if=/home/onyr/Documents/5if/s1/seminaire_witekio_linux/sdcard.img of=/dev/mmcblk0 bs=1M
60+1 records in
60+1 records out
62915072 bytes (63 MB, 60 MiB) copied, 10,2267 s, 6,2 MB/s

```
