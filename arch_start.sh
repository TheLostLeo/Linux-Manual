#!/bin/bash

# =========================================================
# Arch Linux Post Install Script
# Run ONLY after:
# - pacstrap
# - genfstab
# - arch-chroot /mnt
# =========================================================

set -Eeuo pipefail

# =========================================================
# USER VARIABLES
# =========================================================

HOSTNAME=""
USERNAME=""
TIMEZONE="Asia/Kolkata"
LOCALE="en_US.UTF-8"

# Change disk if needed
DISK="/dev/nvme0n1"

# =========================================================
# CONFIRMATION
# =========================================================

echo "========================================="
echo "Arch Linux Installation Script"
echo "========================================="
echo ""
echo "Hostname : ${HOSTNAME}"
echo "Username : ${USERNAME}"
echo "Timezone : ${TIMEZONE}"
echo "Disk     : ${DISK}"
echo ""

read -rp "Continue installation? (y/N): " ans

if [[ "${ans}" != "y" ]]; then
    echo "Installation cancelled."
    exit 1
fi

# =========================================================
# TIMEZONE
# =========================================================

echo ""
echo "Setting timezone..."

ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
hwclock --systohc

# =========================================================
# LOCALE
# =========================================================

echo ""
echo "Generating locale..."

sed -i "s/^#${LOCALE}/${LOCALE}/" /etc/locale.gen

locale-gen

echo "LANG=${LOCALE}" > /etc/locale.conf

# =========================================================
# HOSTNAME
# =========================================================

echo ""
echo "Setting hostname..."

echo "${HOSTNAME}" > /etc/hostname

cat > /etc/hosts <<EOF
127.0.0.1 localhost
::1 localhost
127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}
EOF

# =========================================================
# KEYMAP
# =========================================================

echo "KEYMAP=us" > /etc/vconsole.conf

# =========================================================
# ROOT PASSWORD
# =========================================================

echo ""
echo "Set ROOT password"
passwd

# =========================================================
# INSTALL PACKAGES
# =========================================================

echo ""
echo "Installing packages..."

pacman -S --noconfirm \
networkmanager \
grub \
efibootmgr \
sudo \
nano \
neovim \
git \
base-devel \
linux-headers \
os-prober \
intel-ucode \
pipewire \
pipewire-pulse \
wireplumber \
bluetooth \
bluez \
bluez-utils

# =========================================================
# ENABLE SERVICES
# =========================================================

echo ""
echo "Enabling services..."

systemctl enable NetworkManager
systemctl enable bluetooth

# =========================================================
# CREATE USER
# =========================================================

echo ""
echo "Creating user..."

useradd -m -G wheel,audio,video,storage,input -s /bin/bash "${USERNAME}"

echo ""
echo "Set password for ${USERNAME}"
passwd "${USERNAME}"

# =========================================================
# ENABLE SUDO
# =========================================================

echo ""
echo "Enabling sudo for wheel group..."

sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# =========================================================
# INITRAMFS
# =========================================================

echo ""
echo "Generating initramfs..."

mkinitcpio -P

# =========================================================
# GRUB INSTALL
# =========================================================

# echo ""
# echo "Installing GRUB..."

# grub-install \
# --target=x86_64-efi \
# --efi-directory=/boot \
# --bootloader-id=GRUB

# =========================================================
# ENABLE WINDOWS DETECTION
# =========================================================

# echo ""
# echo "Enabling os-prober..."

# sed -i 's/^#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub

# =========================================================
# GENERATE GRUB CONFIG
# =========================================================

# echo ""
# echo "Generating GRUB configuration..."

# grub-mkconfig -o /boot/grub/grub.cfg

# =========================================================
# FINISHED
# =========================================================

echo ""
echo "========================================="
echo "Installation Complete"
echo "========================================="
echo ""
echo "Exit chroot and reboot:"
echo ""
echo "exit"
echo "umount -R /mnt"
echo "reboot"
echo ""
