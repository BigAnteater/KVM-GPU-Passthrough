#!/bin/bash

if [ $EUID -ne 0 ]
	then
		echo "This program must run as root to function." 
		exit 1
fi
echo "This will install and configure libvirt. Only run once."
sleep 1s
dnf install libvirt libvirt-glib libvirt-python virt-install virt-manager qemu qemu-common ebtables dnsmasq bridge-utils iptables swtpm
sleep 1s
systemctl enable libvirtd
echo "systemctl enable libvirtd"
sleep 1s
systemctl start libvirtd
echo "systemctl start libvirtd"
clear
echo "Will ask to copy your configs"
cp -i /etc/libvirt/libvirtd.conf /etc/libvirt/libvirtd.conf.old
sleep 1s
echo "What is your username?"
read USERNAME
sleep 1s
clear
echo "Adding $USERNAME to kvm and libvirt groups..."
gpasswd -M $USERNAME kvm
gpasswd -M $USERNAME libvirt
sleep 2s
clear
mv libvirtd.conf /etc/libvirt append 2>/dev/null
echo "mv libvirtd.conf /etc/libvirt"
sleep 1s
clear
echo "libvirt has been successfully configured!"
cp -i /etc/libvirt/qemu.conf /etc/libvirt/qemu.conf.old
sleep 1s
echo "mv qemu.conf /etc/libvirt"
mv qemu.conf /etc/libvirt append 2>/dev/null
sleep 1s
clear
systemctl restart libvirtd
echo "QEMU has been successfully configured!"
sleep 5s
exit
