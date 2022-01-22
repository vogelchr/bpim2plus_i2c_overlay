all : boot.scr overlay.dtb

.PHONY : clean install
clean :
	rm -f *~ *.dtb orig.dts *.scr

install : boot.scr overlay.dtb
	install -m644 boot.cmd /boot.cmd
	install -m644 boot.scr /boot.scr
	install -m644 overlay.dtb /boot/overlay.dtb

orig.dts :
	dtc -I fs -O dts /proc/device-tree >orig.dts

overlay.dtb : overlay.dts
	dtc -@ -I dts -O dtb $^ >$@ || (rm -f $@ ; false)

boot.scr : boot.cmd
	mkimage -C none -A arm -T script -d boot.cmd boot.scr
