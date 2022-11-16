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
