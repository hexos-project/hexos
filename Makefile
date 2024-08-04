KERNEL=octox/kernel.elf
INITRD=initrd
SYS=$(INITRD)/sys
CONFIG=iconfig
IMAGE=image.iso

all: image test

test:
	@echo "    VM\t$(IMAGE)"
	@qemu-system-x86_64 -m 4096 -enable-kvm -cpu host -smp 12 -cdrom $(IMAGE) -serial stdio -bios /usr/share/ovmf/OVMF.fd

kern: gitmods-upd
	@echo "    MK\t$(KERNEL)"
	@make -C octox --no-print-directory

bootboot/mkbootimg/mkbootimg: gitmods-upd
	@echo "    MK\t$mkbootimg"
	@make -C bootboot/mkbootimg --no-print-directory

initramd: kern
	@echo "    MK\t$(INITRD)"
	@cp $(KERNEL) $(SYS)

image: initramd bootboot/mkbootimg/mkbootimg
	@echo "    MK\t$(IMAGE)"
	@bootboot/mkbootimg/mkbootimg $(CONFIG) $(IMAGE)

gitmods-upd:
	@echo "    UPD\tGITMODS"
	cd octox
	git fetch
	git pull origin main --rebase
	cd ..
	git add octox
	git add bootboot
	git commit -m "UPD: octox submodule updated"
	git push origin main --force
