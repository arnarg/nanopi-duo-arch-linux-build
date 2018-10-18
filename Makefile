UBOOT_DEFCONFIG ?= nanopi_duo_defconfig
UBOOT_DIR ?= u-boot
UBOOT_TAG ?= v2018.09
BOARD_TARGET ?= nanopi-duo
TOOLCHAIN ?= arm-none-eabi-

UBOOT_OUTPUT_DIR ?= $(CURDIR)/tmp/u-boot-${BOARD_TARGET}
UBOOT_MAKE ?= make -C $(UBOOT_DIR) KBUILD_OUTPUT=$(UBOOT_OUTPUT_DIR) CROSS_COMPILE="$(TOOLCHAIN)"

img: ArchLinuxARM-armv7-latest.tar.gz u-boot-build
	guestfish -N out/ArchLinuxARM-NanoPi-Duo.img \
	-a $(UBOOT_OUTPUT_DIR)/u-boot-sunxi-with-spl.bin -f create.gfs -x

img.xz: img
	xz $<

ArchLinuxARM-armv7-latest.tar.gz:
	wget http://archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz

u-boot:
	git clone --branch $(UBOOT_TAG) https://github.com/u-boot/u-boot.git $(UBOOT_DIR)
	patch -p0 < patch/add-nanopi-duo.patch

u-boot-build: u-boot
	$(UBOOT_MAKE) $(UBOOT_DEFCONFIG)
	$(UBOOT_MAKE) -j $$(nproc)

clean:
	rm -rf out tmp

superclean:
	rm -rf u-boot ArchLinuxARM-armv7-latest.tar.gz
