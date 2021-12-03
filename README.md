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

And then you should be good to go.

**Preparing GRUB**

Preparing GRUB is very simple. Just follow these instructions.

1) Clone the repository: ```https://github.com/BigAnteater/KVM-GPU-Passthrough```
