# Arch Linux Installation Guide

A beginner-friendly Arch Linux installation guide with:
- Manual installation steps
- UEFI support
- Dual boot support
- GRUB setup
- Post-install automation script

---

# Requirements

Before starting:

- Backup important data
- Disable Secure Boot
- Create a bootable Arch Linux USB
- Boot in UEFI mode

Download Arch Linux ISO:
https://archlinux.org/download/

---

# Boot Into Arch ISO

After booting into the live environment:

```bash
ping archlinux.org
```

If using WiFi:

```bash
iwctl
```

Inside iwctl:

```bash
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect WIFI_NAME
exit
```

---

# Identify Disks

```bash
lsblk
```

Example NVMe drive:

```bash
/dev/nvme0n1
```

---

# Partitioning (UEFI)

Open cfdisk:

```bash
cfdisk /dev/nvme0n1
```

Create:

| Partition | Size | Type |
|---|---|---|
| EFI | 512M | EFI System |
| Swap | Optional | Linux Swap |
| Root | Remaining | Linux filesystem |

If dual booting with Windows:
- Reuse the existing EFI partition
- DO NOT format the EFI partition

---

# Format Partitions

Example:

| Partition | Usage |
|---|---|
| nvme0n1p1 | EFI |
| nvme0n1p2 | Swap |
| nvme0n1p3 | Root |

Format root:

```bash
mkfs.ext4 /dev/nvme0n1p3
```

Format EFI:

```bash
mkfs.fat -F32 /dev/nvme0n1p1
```

Create swap:

```bash
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
```

---

# Mount Partitions

```bash
mount /dev/nvme0n1p3 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

---

# Install Base System

```bash
pacstrap -K /mnt base linux linux-firmware base-devel \
networkmanager sudo grub efibootmgr \
nano neovim git
```

Generate fstab:

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Chroot into system:

```bash
arch-chroot /mnt
```

---

# Download Installation Script

```bash
git clone https://github.com/USERNAME/REPOSITORY.git
cd REPOSITORY
chmod +x arch_install.sh
./arch_install.sh
```

---

# Install GRUB

```bash
grub-install --target=x86_64-efi \
--efi-directory=/boot \
--bootloader-id=GRUB
```

Generate config:

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

---

# Enable Windows Detection

Install os-prober:

```bash
pacman -S os-prober
```

Enable os-prober:

```bash
nano /etc/default/grub
```

Uncomment:

```bash
GRUB_DISABLE_OS_PROBER=false
```

Regenerate GRUB:

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

---

# Finish Installation

Exit chroot:

```bash
exit
```

Unmount:

```bash
umount -R /mnt
```

Reboot:

```bash
reboot
```

Remove USB after reboot.

---

# Post Install

Update system:

```bash
sudo pacman -Syu
```

Enable Bluetooth:

```bash
sudo systemctl enable bluetooth
```

Install audio packages:

```bash
sudo pacman -S pipewire pipewire-pulse wireplumber
```

---

# Notes

- NVIDIA users should install NVIDIA drivers
- AMD users usually only need mesa
- Intel users should install intel-ucode
- AMD users should install amd-ucode

---

# License

MIT
