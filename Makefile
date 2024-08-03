KERNEL=kernel/kernel.elf
INITRD=initrd
SYS=$(INITRD)/sys
TMPCONFIG=/tmp/config.json
CONFIG=iconfig
IMAGE=image.iso

all: image test

test:
	qemu-system-x86_64 -m 4096 -enable-kvm -cpu host -smp 12 -cdrom $(IMAGE) -serial stdio -bios /usr/share/ovmf/OVMF.fd

kern:
	make -C kernel

initramd: kern
	cp $(KERNEL) $(SYS)

image: initramd
	cp $(CONFIG) $(TMPCONFIG)
	utils/mkbootimg $(TMPCONFIG) $(IMAGE)
	rm $(TMPCONFIG)
