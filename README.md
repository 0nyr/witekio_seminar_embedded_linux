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
6. Overwritte the partition on the SD card and copy the image to it with the following command: `dd if=/path/to/sdcard.img of=/dev/<sd_card_device> bs=1M`.
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
9. You can check the linux image has been correctly install to the mount point, here `/mnt` that should contain the files.
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



