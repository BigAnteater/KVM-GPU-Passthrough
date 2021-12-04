# KVM-GPU-Passthrough

If you wa

**Preparations**

To prepare, make sure you have virtualization enabled in your BIOS.

For AMD this could be done by enabling

  • IOMMU
  • NX Mode
  • SVM Mode

For you lame Intel users, just enable

  • VT-d
  • VT-x

And then clone the repository by typing:

``git clone https://github.com/BigAnteater/KVM-GPU-Passthrough/ && cd KVM-GPU-Passthrough``

And then you should be good to go.

**Preparing GRUB**

Preparing GRUB is very simple. Just follow these instructions.

1) Mark the script as executable: for AMD: ``chmod +x grub_setup_amd.sh`` for Intel: ``chmod +x grub_setup_intel.sh``.
2) Then run the script: AMD: ``sudo ./grub_setup_amd.sh`` Intel: ``sudo ./grub_setup_intel.sh``.
3) Then just follow the instructions in script!

**Configuring Libvirt**

To configure libvirt run my script which configures libvirt and QEMU for you by typing ``./libvirt_configuration.sh``.

**Patching your ROM**

1) Go to https://www.techpowerup.com/vgabios/ and download the ROM of your ***exact*** GPU.
![Screen Capture_select-area_20211203200439](https://user-images.githubusercontent.com/77298458/144696258-5a424e34-236a-4e20-adf7-723068707712.png)
2) Once you have your rom downloaded, type in ``sudo pacman -S bless`` to download the hex editor to patch your rom.
3) Open your ROM with the Bless hex editor, and as muta says: "This is where the real arcane s#!% happens."
4) Press CTRL + F to search, and search for "VIDEO" as text.
![Screen Capture_select-area_20211203201054](https://user-images.githubusercontent.com/77298458/144696438-6e7afb3e-b808-4bc7-a0be-8683c046f445.png)
5) Then, delete everything before the "U.s", and save your ROM as something simple (i.e: patch.rom), and you should have your be good to go!
![Screen Capture_select-area_20211203201250](https://user-images.githubusercontent.com/77298458/144696539-44ce50f6-c6fd-4d2d-9564-3be3fd663585.png)
6) Once your ROM has been patched, open your terminal in the folder which you have your ROM saved in, and type in ``sudo mkdir /var/lib/libvirt/vbios/ && mv patch.rom /var/lib/libvirt/vbios``
7) Then your ROM should be all patched and good to go!
