KERNEL=octox/kernel.elf
INITRD=initrd
SYS=$(INITRD)/sys
CONFIG=iconfig
IMAGE=image.iso

.IGNORE: gitmods-upd mkbootimg

all: image test

test:
	@echo "    VM\t$(IMAGE)"
	@qemu-system-x86_64 -m 4096 -enable-kvm -cpu host -smp 12 -cdrom $(IMAGE) -serial stdio -bios /usr/share/ovmf/OVMF.fd

kern: gitmods-upd
	@echo "    MK\t$(KERNEL)"
	@make -C octox --no-print-directory

mkbootimg:
	@echo "    GET\tMKBOOTIMG"
	@wget https://gitlab.com/bztsrc/bootboot/-/raw/binaries/mkbootimg-Linux.zip > /dev/null 2>&1
	@unzip mkbootimg-Linux.zip > /dev/null 2>&1
	@chmod +x mkbootimg > /dev/null 2>&1
	@rm -f mkbootimg-Linux.zip > /dev/null 2>&1
	@rm -f DESCRIPT.ION > /dev/null 2>&1

initramd: kern
	@echo "    MK\t$(INITRD)"
	@cp $(KERNEL) $(SYS)

image: initramd mkbootimg
	@echo "    MK\t$(IMAGE)"
	@./mkbootimg $(CONFIG) $(IMAGE)

gitmods-upd:
	@echo "    UPD\tGITMODS"
	@rm -rf octox > /dev/null 2>&1
	@git clone https://github.com/hexos-project/octox-x86_64.git octox > /dev/null 2>&1
