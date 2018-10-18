UBOOT_DEFCONFIG ?= nanopi_duo_defconfig
UBOOT_DIR ?= u-boot
UBOOT_TAG ?= v2018.09
BOARD_TARGET ?= nanopi-duo
TOOLCHAIN ?= arm-none-eabi-

OUTPUT_DIR ?= $(CURDIR)/out
OUTPUT_FILE ?= ArchLinuxARM-NanoPi-Duo.img

UBOOT_OUTPUT_DIR ?= $(CURDIR)/tmp/u-boot-${BOARD_TARGET}

$(OUTPUT_DIR)/$(OUTPUT_FILE): ArchLinuxARM-armv7-latest.tar.gz $(UBOOT_OUTPUT_DIR) $(OUTPUT_DIR)
	guestfish -N $(OUTPUT_DIR)/$(OUTPUT_FILE)=disk:2G \
	-a $(UBOOT_OUTPUT_DIR)/u-boot-sunxi-with-spl.bin -f create.gfs -x

$(OUTPUT_DIR)/$(OUTPUT_FILE).xz: $(OUTPUT_DIR)/$(OUTPUT_FILE)
	xz $<

.PHONY: img.xz
img.xz: $(OUTPUT_DIR)/$(OUTPUT_FILE).xz

ArchLinuxARM-armv7-latest.tar.gz:
	wget http://archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

clean:
	rm -rf out tmp

superclean: clean
	rm -rf u-boot ArchLinuxARM-armv7-latest.tar.gz

include Makefile.uboot.mk
