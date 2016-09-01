### Additional Instructions

### Resize the SD card
After booting for the first time, the partition may expand to fill the entire SD card.  This is not necessarily a bad thing,
but it takes longer to created subsequent SD cards due to the size of the disk image.  Follow these instructions to resize
the SD card.  The instructions here are for a Linux host and assume some familiarity with things like mounting an unmounting 
partitions.

1. Insert the card into the SD card slot into the computer.  Two partitions should get mounted.  Unmount the two partitions.
2. Check the file system
   
   ```bash
   sudo e2fsck -f /dev/mmcblk0p2
   e2fsck 1.42.13 (17-May-2015)
   Pass 1: Checking inodes, blocks, and sizes
   Pass 2: Checking directory structure
   Pass 3: Checking directory connectivity
   Pass 4: Checking reference counts
   Pass 5: Checking group summary information
   /dev/mmcblk0p2: 35424/957712 files (0.2% non-contiguous), 282993/3872384 blocks
   ```
3. Shrink the file system:
   
   ```bash
   sudo resize2fs /dev/mmcblk0p2 4G
   resize2fs 1.42.13 (17-May-2015)
   Resizing the filesystem on /dev/mmcblk0p2 to 1048576 (4k) blocks.
   The filesystem on /dev/mmcblk0p2 is now 1048576 (4k) blocks long.
   ```
   
2. Open the card in fdisk: `fdisk /dev/mmcblk0`
3. List the partitions:
   ```bash
   Command (m for help): p
   Disk /dev/mmcblk0: 14.9 GiB, 15931539456 bytes, 31116288 sectors
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   Disklabel type: dos
   Disk identifier: 0x02559a02

   Device         Boot  Start      End  Sectors  Size Id Type
   /dev/mmcblk0p1        8192   137215   129024   63M  c W95 FAT32 (LBA)
   /dev/mmcblk0p2      137216 31116287 30979072 14.8G 83 Linux
   ```
   This example shows the partitions for a 16GB SD card.  The second partion is the one that will be resized.
4. Remove the second partion: 
  ```bash
  Command (m for help): d
  Partition number (1,2, default 2): 2
  
  Partition 2 has been deleted.
  ```
5. Create a new 4GB partition:
  ```bash
  Command (m for help): n
  Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
  Select (default p): p
  Partition number (2-4, default 2): 2
  First sector (2048-31116287, default 2048): 137216
  Last sector, +sectors or +size{K,M,G,T,P} (137216-31116287, default 31116287): +4G 

  Created a new partition 2 of type 'Linux' and of size 4 GiB.

  Command (m for help): p
  Disk /dev/mmcblk0: 14.9 GiB, 15931539456 bytes, 31116288 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 512 bytes
  I/O size (minimum/optimal): 512 bytes / 512 bytes
  Disklabel type: dos
  Disk identifier: 0x02559a02

  Device         Boot  Start     End Sectors Size Id Type
  /dev/mmcblk0p1        8192  137215  129024  63M  c W95 FAT32 (LBA)
  /dev/mmcblk0p2      137216 8525823 8388608   4G 83 Linux
  ```
  Note that the starting sector for the new partition is the same as the one that was deleted.
6. Write the changes and exit:
  
  ```bash
  Command (m for help): w
  The partition table has been altered.
  Calling ioctl() to re-read partition table.
  Syncing disks.
  ```
  
  You should now be back at the command prompt.
  
7. Rerun `e2fsck` to make sure the changed file system is ok:
   
   ```
   sudo e2fsck -f /dev/mmcblk0p2
   e2fsck 1.42.13 (17-May-2015)
   Pass 1: Checking inodes, blocks, and sizes
   Pass 2: Checking directory structure
   Pass 3: Checking directory connectivity
   Pass 4: Checking reference counts
   Pass 5: Checking group summary information
   /dev/mmcblk0p2: 35424/257536 files (0.2% non-contiguous), 238898/1048576 blocks
   ```
10. Boot the resized SD card!
11. Celebrate!!!

