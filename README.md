# Linux-Manual
This is a basic repo form myself about the installation ,using and building of my arch linux

iso file download link :https://archlinux.org/download

The code used to check the version of the linux iso:

<code>$ pacman-key -v archlinux-version-x86_64.iso.sig</code>

partition the drive(ssd,usb etc)

for finding the list of the drive use:
<code>lsblk</code>

The partition should have three partition (boot,swap and the main os)


/boot - /dev/efi -efi system partition -1gb (fat32)

[swap] -/dev/swap -linux swap- 4gb (swap)

/ root -/dev/root -linux root - 32gb (ext4)

The code for partition is:

<code>mkswap /dev/(swap_partition)</code>

<code>mkfs.fat -F 32 /dev/(efi_partition)</code>

<code>mkfs.ext4 /dev/(root_partition)</code>

mounting the partition

Mount the root volume to /mnt

<code>mount /dev/root_partition /mnt</code>

For UEFI systems, mount the EFI system partition

<code>mount --mkdir /dev/efi_system_partition /mnt/boot</code>


for swap

<code>swapon /dev/swap_partition</code>





