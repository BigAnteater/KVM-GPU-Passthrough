#!/bin/bash

if [ $EUID -ne 0 ]
        then
                echo "This program must run as root to function." 
                exit 1
fi

echo "This script will configure your grub config for virtualization."

GRUB=`cat /etc/default/grub | grep "GRUB_CMDLINE_LINUX" | rev | cut -c 2- | rev`
#adds amd_iommu=on and iommu=pt to the grub config
GRUB+=" amd_iommu=on iommu=pt video=efifb:off\""
sed -i -e "s|^GRUB_CMDLINE_LINUX.*|${GRUB}|" /etc/default/grub

grub2-mkconfig -o /boot/grub2/grub.cfg && grub2-mkconfig -o /boot/efi/EFI/Fedora/grub.cfg
sleep 5s
clear            
echo
echo "Grub bootloader has been modified successfully, reboot time!"
echo "press Y to reboot now and n to reboot later."
read REBOOT

if [ $REBOOT = "Y" ]
        then
                reboot
fi
exit
