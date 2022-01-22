# after modifying this file, run
# mkimage -C none -A arm -T script -d boot.cmd boot.scr

part uuid ${devtype} ${devnum}:${bootpart} uuid
setenv bootargs console=${console} root=PARTUUID=${uuid} rw rootwait audit=0

# required for SMP operation, see
# https://linux-sunxi.org/PSCI
setenv bootm_boot_mode nonsec


if load ${devtype} ${devnum}:${bootpart} ${kernel_addr_r} /boot/zImage; then
  if load ${devtype} ${devnum}:${bootpart} ${fdt_addr_r} /boot/dtbs/${fdtfile}; then
    fdt addr ${fdt_addr_r};
    if load ${devtype} ${devnum}:${bootpart} ${fdtoverlay_addr_r} /boot/overlay.dtb; then
      fdt resize 8192;
      fdt apply ${fdtoverlay_addr_r};
    fi;
    if load ${devtype} ${devnum}:${bootpart} ${ramdisk_addr_r} /boot/initramfs-linux.img; then
      bootz ${kernel_addr_r} ${ramdisk_addr_r}:${filesize} ${fdt_addr_r};
    else
      bootz ${kernel_addr_r} - ${fdt_addr_r};
    fi;
  fi;
fi

if load ${devtype} ${devnum}:${bootpart} 0x48000000 /boot/uImage; then
  if load ${devtype} ${devnum}:${bootpart} 0x43000000 /boot/script.bin; then
    setenv bootm_boot_mode sec;
    bootm 0x48000000;
  fi;
fi
