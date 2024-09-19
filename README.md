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


Then do the installation

we install mirrors 

do the code in order

to install base packages and git if needed

<code>pacstrap -K /mnt base linux linux-firmware neovim nano</code>

to make usure the file are there on bootup

<code>genfstab -U /mnt > /mnt/etc/fstab</code>

changing root

<code> arch-chroot /mnt</code>

open the arch_start.sh on nvim and update the hostname ,username, disk, grub install and save the file

run the arch_start.sh using

<code> bash filename </code>

if issuse with wifi or ethernet install network manager 

<code> sudo pacman -S networkmanager</code>

after that enable the network manager

<code>sudo systemctl enable NetworkManager</code>

<code>sudo systemctl start NetworkManager</code>

the default shell is bash and it can be changed to other shells like fish or zsh

(for my system it is zsh)

run command to install zsh

<code>sudo pacman -S zsh</code>

this install the zsh into the system

then run the below code to change the shell from bash to zsh

<code>chsh -s /bin/zsh</code>










