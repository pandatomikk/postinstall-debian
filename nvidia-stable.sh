#!/bin/bash

# Root checker
if [[ $EUID -ne 0 ]]; then
	echo -e "\n---------------------------------------\n"
    echo -e "You need to be logged as root (su- / sudo -i)" 1>&2
    echo -e "\n---------------------------------------\n"
	exit 1
fi

clear

echo "Job start : Installing Nvidia Pro Drivers + Cuda
"
sleep 2

echo "*** BUG DEBIAN 12 LIVE ISOS :

Le paquet raspi-firmware installé par défaut dans ces isos est cassée, empêchant la mise à jour de l'initramfs.
Par sécurité, il sera désinstallé et nettoyé. Si vous en avez besoin, considérez le bug et prenez un paquet plus récent en provenance de Sid sur pkgs.org ***

NOTE : Un clean de vulkan/mesa/nvidia sera effectué pour éviter tout conflit. En cas de necessité, vous devrez reinstaller mesa-vulkan-drivers mesa-vulkan-drivers:i386 (INTEL/AMD).


"
sleep 5

apt autopurge -y raspi-firmware
rm /etc/initramfs/post-update.d/z50-raspi-firmware

echo "
Préparation des dépendances :
"
sleep 2

dpkg --add-architecture i386
add-apt-repository -y contrib
add-apt-repository -y non-free

apt install -y linux-headers-amd64 build-essential dkms libglvnd-dev firmware-misc-nonfree pkg-config

echo "
Nettoyage du système :
"
sleep 2

apt autopurge -y libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386 nvidia* nvidia*:i386

echo "
Installation du driver et de Vulkan + Lib32 :
"
sleep 2

apt install -y nvidia-driver libvulkan* 
apt install -y libvulkan*:i386 nvidia-driver-libs:i386

echo "
Installation de Cuda :
"
sleep 2

apt install -y nvidia-cuda-toolkit nvidia-cuda-dev

echo "

Job done
"

echo "
Veuillez REBOOT la machine !!
"
