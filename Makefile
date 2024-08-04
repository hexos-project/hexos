KERNEL=octox/kernel.elf
INITRD=initrd
SYS=$(INITRD)/sys
CONFIG=iconfig
IMAGE=image.iso

all: image test

test:
	qemu-system-x86_64 -m 4096 -enable-kvm -cpu host -smp 12 -cdrom $(IMAGE) -serial stdio -bios /usr/share/ovmf/OVMF.fd

kern: gitmods-upd
	make -C octox

bootboot/mkbootimg/mkbootimg: gitmods-upd
	make -C bootboot/mkbootimg

initramd: kern
	cp $(KERNEL) $(SYS)

image: initramd bootboot/mkbootimg/mkbootimg
	bootboot/mkbootimg/mkbootimg $(CONFIG) $(IMAGE)

gitmods-upd:
	git submodule update
