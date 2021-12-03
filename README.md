# KVM-GPU-Passthrough


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

1) Mark the script as executable: for AMD: ``chmod +x grub_setup_amd.sh`` for Intel: ``chmod +x grub_setup_intel.sh``
2) Then run the script: AMD: ``sudo ./grub_setup_amd.sh`` Intel: ``sudo ./grub_setup_intel.sh``
3) Then just follow the instructions in script!

**Configuring Libvirt**

To configure libvirt run my script which configures libvirt and QEMU for you by typing ``./libvirt_configuration.sh``
