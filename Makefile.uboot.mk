UBOOT_MAKE ?= make -C $(UBOOT_DIR) KBUILD_OUTPUT=$(UBOOT_OUTPUT_DIR) CROSS_COMPILE="$(TOOLCHAIN)"

u-boot:
	git clone --branch $(UBOOT_TAG) https://github.com/u-boot/u-boot.git $(UBOOT_DIR)
	patch -p0 < patch/add-nanopi-duo.patch

$(UBOOT_OUTPUT_DIR): u-boot
	$(UBOOT_MAKE) $(UBOOT_DEFCONFIG)
	$(UBOOT_MAKE) -j $$(nproc)
