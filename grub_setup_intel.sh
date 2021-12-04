if [ $EUID -ne 0 ]
        then
                echo "This program must run as root to function." 
                exit 1
fi

echo "This script will configure your grub config for virtualization."

#adds intel_iommu=on and iommu=pt to the grub config
GRUB+=" intel_iommu=on iommu=pt\""
sed -i -e "s|^GRUB_CMDLINE_LINUX_DEFAULT.*|${GRUB}|" /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg

sleep 5s

echo
echo "Grub bootloader has been modified successfully, reboot time!"
echo "press Y to reboot now and n to reboot later."
read REBOOT

if [ $REBOOT = "y" ]
	then
		reboot
fi

done
