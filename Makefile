THEOS = ../path/to/theos
ARCHS = arm64 


ifeq ($(SCHEME), rootful)
    THEOS_PACKAGE_DIR = debs/rootful
else ifeq ($(SCHEME), rootless)
    THEOS_PACKAGE_SCHEME = rootless
    THEOS_PACKAGE_DIR = debs/rootless
else ifeq ($(SCHEME), jailed)
    THEOS_PACKAGE_DIR = debs/jailed
endif


# ====== your makefile =====
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = 0x00
$(TWEAK_NAME)_CFLAGS = -fobjc-arc 
$(TWEAK_NAME)_FILES = tweak.m
include $(THEOS_MAKE_PATH)/tweak.mk
# ==============================



after-package::
	@echo "Đổi tên file .deb..."
	@if [ -n "$(SCHEME)" ]; then \
		if [ "$(SCHEME)" = "rootful" ]; then \
			NEW_NAME="rootful-lqmb.deb"; \
		elif [ "$(SCHEME)" = "rootless" ]; then \
			NEW_NAME="rootless-lqmb.deb"; \
		elif [ "$(SCHEME)" = "roothide" ]; then \
			NEW_NAME="roothide-lqmb.deb"; \
		else \
			NEW_NAME="nonroot-lqmb.deb"; \
		fi; \
		if ls $(THEOS_PACKAGE_DIR)/*.deb >/dev/null 2>&1; then \
			for deb in $(THEOS_PACKAGE_DIR)/*.deb; do \
				mv "$$deb" "$(THEOS_PACKAGE_DIR)/$$NEW_NAME" && \
				echo "Đã đổi tên thành $(THEOS_PACKAGE_DIR)/$$NEW_NAME"; \
			done; \
		else \
			echo "Thất bại: không tìm thấy file .deb trong $(THEOS_PACKAGE_DIR)/."; \
			exit 1; \
		fi; \
	else \
		echo "Thất bại: SCHEME không được định nghĩa."; \
		exit 1; \
	fi