# Single KVM-GPU-Passthrough

If you want a video guide to walk you through this, check out my tutorial: https://youtu.be/R5c25kV4tZ0

***THIS GUIDE IS MEANT ARCH LINUX USERS***

### Preparations

To prepare, make sure you have virtualization enabled in your BIOS.

For AMD this could be done by enabling

  • IOMMU
  • NX Mode
  • SVM Mode

For you lame Intel users, just enable

  • VT-d
  • VT-x

And then clone the repository by typing:

```
git clone https://github.com/BigAnteater/KVM-GPU-Passthrough/ && cd KVM-GPU-Passthrough
```

And then you should be good to go.

### Preparing GRUB

Preparing GRUB is very simple. Just follow these instructions.

1) Mark the script as executable: for AMD: ``chmod +x grub_setup_amd.sh`` for Intel: ``chmod +x grub_setup_intel.sh``.
2) Then run the script: AMD: ``sudo ./grub_setup_amd.sh`` Intel: ``sudo ./grub_setup_intel.sh``.
3) Then just follow the instructions in script!

### Configuring Libvirt

To configure libvirt run my script which configures libvirt and QEMU for you by typing ``sudo ./libvirt_configuration.sh``.

### Setting up Virt Manager

1) Download the latest ISO for Windows 10 from: https://www.microsoft.com/en-us/software-download/windows10ISO.
2) Open up Virt Manager and create a new virtual machine.
3) Select local install media, and choose your Windows 10 ISO. Then choose how much ram you want, and how many CPUs you want. You can select your own custom storage, but for the sake of this guide I will be using the default location. Make sure to allocate at least 60 gigabytes.
5) Name the Virtual Machine Win10, and tick the box which says customize configuration before install.
6) Make sure your firmware is set to OVMF_CODE.fd, because you need the special UEFI firmware for the VM to boot properly.
![Screen Capture_virt-manager_20211203210303](https://user-images.githubusercontent.com/77298458/144697907-4a5b9099-9415-45df-8a3c-a44274dde6e6.png)

7) Then go into the CPU options and change it so that it looks like the picture below. Change the ammount of cores to however many CPU cores you want, and make sure to set the threads ammount to 2 because it will give 2 threads to every 1 core.
![Screen Capture_virt-manager_20211203210507](https://user-images.githubusercontent.com/77298458/144697973-239be762-9928-4b9e-a475-9f5ed9bb112a.png)

8) Lastly, go into your boot settings and make sure that your optical disk is checked.
![Screen Capture_virt-manager_20211203210927](https://user-images.githubusercontent.com/77298458/144698047-39cfddde-aa28-4d4c-8f0b-bff81a5c21ca.png)

9) And then you should be able to click begin installation!
10) After you finish installing windows, you should be good to shut down the VM and follow along with the next steps.

### Creating your rom

To create a rom you would need to download the following tools in a windows machine (dualboot), if you are dualbooting from windows be sure to create a backup with cloning software i personally use acronis but you can use clonezilla if that's a thing; just be sure you have an addtional hard drive around and that drive has enough space for all partitions.

1) Gpu-Z

Download GPU-Z here at https://www.techpowerup.com/gpuz/

click on what has been circled and click write to file, it will save it as a rom; be sure to save it to where arch has access to it otherwise you will have to create a mount point. For AMD users the process should be the same.

![SavingBios](https://user-images.githubusercontent.com/68661602/150429190-1fa45b23-c6b0-4a4b-9d32-ed4f98c453d8.png)

### Viewing VBios from arch

To view the vbios from arch you will simply need to install nvida-settings for nvidia users, then on the GPU tab you will be able to view the vbios.

![FahGRWf](https://user-images.githubusercontent.com/68661602/150429338-c041e1c9-3f23-4bd8-ab5a-3570580a03bf.png)

then do some google-fu site:techpowerup.com  <vbios goes here>
  
  Example site:techpowerup.com 86.04.99.00.06

### AMD Users

You would have to try this tool, haven't tried it because I do not have an AMD gpu; sorry.
https://andrealmeid.com/post/2020-05-01-vbios2/

just simply follow the instructions on how to save the vbios in linux, do not write.


### Patching your ROM

1) Go to https://www.techpowerup.com/vgabios/ and download the ROM of your ***exact*** GPU (or do some google-fu), also be sure it's your exact GPU as well.
  
![Screen Capture_select-area_20211203200439](https://user-images.githubusercontent.com/77298458/144696258-5a424e34-236a-4e20-adf7-723068707712.png)
  
2) Once you have your rom downloaded, type in ``sudo pacman -S bless`` to download the hex editor to patch your rom.
  
3) Open your ROM with the Bless hex editor, and as muta says: "This is where the real arcane s#!% happens."
  
4) Press CTRL + F to search, and search for "VIDEO" as text.
  
![Screen Capture_select-area_20211203201054](https://user-images.githubusercontent.com/77298458/144696438-6e7afb3e-b808-4bc7-a0be-8683c046f445.png)
5) Then, delete everything before the "U.s" or "U.y" or whatever, and save your ROM as something simple (i.e: patch.rom).
  
![Screen Capture_select-area_20211203201250](https://user-images.githubusercontent.com/77298458/144696539-44ce50f6-c6fd-4d2d-9564-3be3fd663585.png)
  
6) Once your ROM has been patched, open your terminal in the folder which you have your ROM saved in, and type in ``sudo mkdir /var/lib/libvirt/vbios/ && sudo mv <RENAME TO YOUR ROM>.rom /var/lib/libvirt/vbios`` and make sure to rename <RENAME TO YOUR ROM> to what you named your ROM.
  
7) Then your ROM should be all patched and good to go!

### Hook Scripts

This is an amazing hook script made by @risingprismtv on gitlab. What this script does is stop your display manager service and all of your running programs, and unhooks your graphics card off of Linux and rehooks it onto the Windows VM.

1) Clone Risngprism's single GPU passthrough gitlab page: ``git clone https://gitlab.com/risingprismtv/single-gpu-passthrough && cd single-gpu-passthrough``.
  
2) Run the install script as sudo: ``sudo ./install-hooks.sh``.
  
3) The scripts will successfully install into their required places without issue!

### Adding your GPU and USB devices to the VM

For the VM to actually pass the gpu, you need to add the PCI device to your VM. Here is how to do so.

*Before we edit pass through our GPU, make sure to enable XML editing.*
  
![Screen Capture_virt-manager_20211204070245](https://user-images.githubusercontent.com/77298458/144714348-ef5a9437-624e-41f7-b94f-9889722c993a.png)




  1) Add every PCI device which has to do with your graphics card to the VM.

  ![Screen Capture_select-area_20211204064804](https://user-images.githubusercontent.com/77298458/144713848-a7918b97-5e1c-4961-b9ec-a9fc1259d777.png)

  2) Pass through your audio device and your USB controller.
  
  ![Screen Capture_virt-manager_20211204065241](https://user-images.githubusercontent.com/77298458/144714016-bf504808-f7ff-4a2f-b533-540d596e794c.png)
  
  3) usb redirect any usb devices that are having issues, i would redirect your headset for headset users and the mouse.
  add hardware > usb host device > the desired device
  
  ![oU1II4D](https://user-images.githubusercontent.com/68661602/150458011-ba7da45d-dfd9-41fe-a7e4-901a2aa0c433.png)

  4) Remember the ROM we patched? Well we're gonna use it now. 

  5) Edit the XML of each passed through PCI device that has to do with your GPU and add the line ``<rom file="/var/lib/libvirt/vbios/<ROMFILE>.rom"/>``. Make sure to rename ROMFILE to what you named your ROM.

  ![Screen Capture_virt-manager_20211204071027](https://user-images.githubusercontent.com/77298458/144714606-ac7d7cfe-b567-492a-a863-08557a58b5c8.png)

  6) Lastly, remove every spice/qxl device from your virtual machine

  ![Screen Capture_virt-manager_20211204071816](https://user-images.githubusercontent.com/77298458/144714841-974cdf8e-57ef-448f-ae2a-cd45809ddae2.png)

  7) If you are using an NVIDIA graphics card, add these lines to your XML overview. Also this could be used to hide your VM, be sure to turn ON hyper-v in windows features.
  
  ![Ic8UR0g](https://user-images.githubusercontent.com/68661602/150457603-8bb1662e-ba13-4a07-baad-7666bebb6088.png)
  
```
  </os>
  <features>
    <acpi/>
    <apic/>
    <hyperv mode="custom">
      <relaxed state="on"/>
      <vapic state="on"/>
      <spinlocks state="on" retries="8191"/>
      <vpindex state="on"/>
      <runtime state="on"/>
      <synic state="on"/>
      <reset state="on"/>
    </hyperv>
    <kvm>
      <hidden state="on"/>
    </kvm>
    <vmport state="off"/>
    <ioapic driver="kvm"/>
  </features>
  <cpu mode="host-passthrough" check="none" migratable="on">
    <topology sockets="1" dies="1" cores="2" threads="2"/>
  </cpu>
  <clock offset="localtime">
    <timer name="rtc" tickpolicy="catchup"/>
    <timer name="pit" tickpolicy="delay"/>
    <timer name="hpet" present="no"/>
    <timer name="hypervclock" present="yes"/>
  </clock>
```

  <details><summary>and for the sake of it, here's a windows 11 example, do not copy paste.</summary>
<p>

```
    <domain type="kvm">
  <name>win11</name>
  <uuid>1ef73810-849a-4a4e-84be-30f90332e603</uuid>
  <metadata>
    <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
      <libosinfo:os id="http://microsoft.com/win/10"/>
    </libosinfo:libosinfo>
  </metadata>
  <memory unit="KiB">16384000</memory>
  <currentMemory unit="KiB">2097152</currentMemory>
  <vcpu placement="static">4</vcpu>
  <os>
    <type arch="x86_64" machine="pc-q35-6.2">hvm</type>
    <loader readonly="yes" type="pflash">/usr/share/edk2-ovmf/x64/OVMF_CODE.secboot.fd</loader>
    <nvram>/var/lib/libvirt/qemu/nvram/win11_VARS.fd</nvram>
    <bootmenu enable="yes"/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <hyperv mode="custom">
      <relaxed state="on"/>
      <vapic state="on"/>
      <spinlocks state="on" retries="8191"/>
      <vpindex state="on"/>
      <runtime state="on"/>
      <synic state="on"/>
      <reset state="on"/>
    </hyperv>
    <kvm>
      <hidden state="on"/>
    </kvm>
    <vmport state="off"/>
    <ioapic driver="kvm"/>
  </features>
  <cpu mode="host-passthrough" check="none" migratable="on">
    <topology sockets="1" dies="1" cores="2" threads="2"/>
  </cpu>
  <clock offset="localtime">
    <timer name="rtc" tickpolicy="catchup"/>
    <timer name="pit" tickpolicy="delay"/>
    <timer name="hpet" present="no"/>
    <timer name="hypervclock" present="yes"/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <pm>
    <suspend-to-mem enabled="no"/>
    <suspend-to-disk enabled="no"/>
  </pm>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type="file" device="disk">
      <driver name="qemu" type="qcow2"/>
      <source file="/var/lib/libvirt/images/win10-3.qcow2"/>
      <target dev="sda" bus="sata"/>
      <boot order="1"/>
      <address type="drive" controller="0" bus="0" target="0" unit="0"/>
    </disk>
    <disk type="file" device="cdrom">
      <driver name="qemu" type="raw"/>
      <source file="/net-ISO/gparted-live-1.0.0-3-amd64.iso"/>
      <target dev="sdb" bus="sata"/>
      <readonly/>
      <boot order="2"/>
      <address type="drive" controller="0" bus="0" target="0" unit="1"/>
    </disk>
    <disk type="block" device="disk">
      <driver name="qemu" type="raw" cache="none" io="native"/>
      <source dev="/dev/sdb"/>
      <target dev="sdc" bus="sata"/>
      <address type="drive" controller="0" bus="0" target="0" unit="2"/>
    </disk>
    <disk type="block" device="disk">
      <driver name="qemu" type="raw" cache="none" io="native"/>
      <source dev="/dev/sdc"/>
      <target dev="sdd" bus="sata"/>
      <address type="drive" controller="0" bus="0" target="0" unit="3"/>
    </disk>
    <disk type="block" device="disk">
      <driver name="qemu" type="raw" cache="none" io="native"/>
      <source dev="/dev/sdd"/>
      <target dev="sde" bus="sata"/>
      <address type="drive" controller="0" bus="0" target="0" unit="4"/>
    </disk>
    <controller type="usb" index="0" model="qemu-xhci" ports="15">
      <address type="pci" domain="0x0000" bus="0x02" slot="0x00" function="0x0"/>
    </controller>
    <controller type="sata" index="0">
      <address type="pci" domain="0x0000" bus="0x00" slot="0x1f" function="0x2"/>
    </controller>
    <controller type="pci" index="0" model="pcie-root"/>
    <controller type="pci" index="1" model="pcie-root-port">
      <model name="pcie-root-port"/>
      <target chassis="1" port="0x10"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x0" multifunction="on"/>
    </controller>
    <controller type="pci" index="2" model="pcie-root-port">
      <model name="pcie-root-port"/>
      <target chassis="2" port="0x11"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x1"/>
    </controller>
    <controller type="pci" index="3" model="pcie-root-port">
      <model name="pcie-root-port"/>
      <target chassis="3" port="0x12"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x2"/>
    </controller>
    <controller type="pci" index="4" model="pcie-root-port">
      <model name="pcie-root-port"/>
      <target chassis="4" port="0x13"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x3"/>
    </controller>
    <controller type="pci" index="5" model="pcie-root-port">
      <model name="pcie-root-port"/>
      <target chassis="5" port="0x14"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x4"/>
    </controller>
    <controller type="pci" index="6" model="pcie-root-port">
      <model name="pcie-root-port"/>
      <target chassis="6" port="0x8"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x0" multifunction="on"/>
    </controller>
    <controller type="pci" index="7" model="pcie-root-port">
      <model name="pcie-root-port"/>
      <target chassis="7" port="0x9"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x1"/>
    </controller>
    <controller type="pci" index="8" model="pcie-root-port">
      <model name="pcie-root-port"/>
      <target chassis="8" port="0xa"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x2"/>
    </controller>
    <controller type="pci" index="9" model="pcie-root-port">
      <model name="pcie-root-port"/>
      <target chassis="9" port="0xb"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x3"/>
    </controller>
    <controller type="pci" index="10" model="pcie-root-port">
      <model name="pcie-root-port"/>
      <target chassis="10" port="0xc"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x4"/>
    </controller>
    <controller type="pci" index="11" model="pcie-to-pci-bridge">
      <model name="pcie-pci-bridge"/>
      <address type="pci" domain="0x0000" bus="0x09" slot="0x00" function="0x0"/>
    </controller>
    <controller type="virtio-serial" index="0">
      <address type="pci" domain="0x0000" bus="0x03" slot="0x00" function="0x0"/>
    </controller>
    <interface type="network">
      <mac address="52:54:00:df:11:29"/>
      <source network="default"/>
      <model type="e1000e"/>
      <address type="pci" domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
    </interface>
    <input type="tablet" bus="usb">
      <address type="usb" bus="0" port="1"/>
    </input>
    <input type="mouse" bus="ps2"/>
    <input type="keyboard" bus="ps2"/>
    <tpm model="tpm-crb">
      <backend type="emulator" version="2.0"/>
    </tpm>
    <audio id="1" type="spice"/>
    <hostdev mode="subsystem" type="pci" managed="yes">
      <source>
        <address domain="0x0000" bus="0x06" slot="0x00" function="0x0"/>
      </source>
      <rom file="/var/lib/libvirt/vbios/1060.rom"/>
      <address type="pci" domain="0x0000" bus="0x05" slot="0x00" function="0x0"/>
    </hostdev>
    <hostdev mode="subsystem" type="pci" managed="yes">
      <source>
        <address domain="0x0000" bus="0x06" slot="0x00" function="0x1"/>
      </source>
      <rom file="/var/lib/libvirt/vbios/1060.rom"/>
      <address type="pci" domain="0x0000" bus="0x06" slot="0x00" function="0x0"/>
    </hostdev>
    <hostdev mode="subsystem" type="pci" managed="yes">
      <source>
        <address domain="0x0000" bus="0x08" slot="0x00" function="0x3"/>
      </source>
      <address type="pci" domain="0x0000" bus="0x07" slot="0x00" function="0x0"/>
    </hostdev>
    <hostdev mode="subsystem" type="pci" managed="yes">
      <source>
        <address domain="0x0000" bus="0x07" slot="0x00" function="0x3"/>
      </source>
      <address type="pci" domain="0x0000" bus="0x08" slot="0x00" function="0x0"/>
    </hostdev>
    <hostdev mode="subsystem" type="usb" managed="no">
      <source>
        <vendor id="0x1038"/>
        <product id="0x1702"/>
      </source>
      <address type="usb" bus="0" port="2"/>
    </hostdev>
    <hostdev mode="subsystem" type="usb" managed="no">
      <source>
        <vendor id="0x0d8c"/>
        <product id="0x0012"/>
      </source>
      <address type="usb" bus="0" port="3"/>
    </hostdev>
    <memballoon model="virtio">
      <address type="pci" domain="0x0000" bus="0x04" slot="0x00" function="0x0"/>
    </memballoon>
  </devices>
</domain>
  
```

</p>
</details>

### notice the sata connections?

These would be used for a Hard Drive pass though, basically handing off your hard drive to the vm.
the process is the same as usb-host, just add the hard drive by selecting storage than manage and the path, usually it starts with /dev/sxx; a good example is /dev/sdc
you can find info about this using sudo fdisk -l

### Editing hooks
This is usefull for people who want to name their VMs to something other than win10.

1) Edit the hooks script by typing ``sudo nano /etc/libvirt/hooks/qemu``

2) On the line with the if then statement, add in ``|| [[ $OBJECT == "RENAME TO YOUR VM" ]]`` before the ;.

![Screen Capture_select-area_20211204074514](https://user-images.githubusercontent.com/77298458/144715662-f66088d0-d0b7-44f7-a515-2df7419af11e.png)

3) Now you should be good to turn on your VM! On Windows drivers will auto install.

### after all is done and you dual-boot

If you want to use gparted to delete the ntfs volume, recovery volume; anything microsoft (except the efi-partitons, unless if that's mounted somewhere else in linux), when finished delete the bios options to boot from windows with efibootmgr

view entries with efibootmgr:
'''
efibootmgr -v
'''

then delete the entry with

'''
efibootmgr -b # -B #
'''

Be careful doing this as this can mess up booting from EFI-bios, be sure to know what you are doing.

### SHOUTOUT TO RisingPrism GITLAB FOR SCRIPTS & IDEA: 

https://gitlab.com/risingprismtv/single-gpu-passthrough/-/wikis/home.

SHOUTOUT TO SomeOrdinaryGamers FOR SOME ASPECTS OF THE GUIDE: https://youtu.be/BUSrdUoedTo. 

https://github.com/pavolelsig/Ubuntu_GVT-g_helper/blob/master/part_1.sh FOR MAKING GRUB SHELL SCRIPT (I changed it to work for arch).

### Also thank you for choosing my guide! it took a lot of time to complete the scripts and readme. Multiple hairs were torn out in the making.
