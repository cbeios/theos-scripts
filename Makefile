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





# Tùy chọn: Đổi tên file .deb trong thư mục packages/<scheme>/
after-package::
	@echo -e "\033[33m==> Đang đổi tên..\033[0m"
	@if [ -n "$(SCHEME)" ]; then \
		if [ "$(SCHEME)" = "rootful" ]; then \
			NEW_NAME="rootfull-lqmb.deb"; \
		elif [ "$(SCHEME)" = "rootless" ]; then \
			NEW_NAME="rootless-lqmb.deb"; \
		elif [ "$(SCHEME)" = "roothide" ]; then \
			NEW_NAME="roothide-lqmb.deb"; \
		else \
			NEW_NAME="nonroot-lqmb.deb"; \
		fi; \
		mkdir -p $(THEOS_PACKAGE_DIR); \
		PACKAGE_FILE=$$(ls $(THEOS_PACKAGE_DIR)/$(THEOS_PACKAGE_NAME)_*.deb 2>/dev/null | head -n 1); \
		if [ -z "$$PACKAGE_FILE" ]; then \
			PACKAGE_FILE=$$(ls $(THEOS_PACKAGE_DIR)/*.deb 2>/dev/null | head -n 1); \
		fi; \
		if [ -n "$$PACKAGE_FILE" ] && [ -f "$$PACKAGE_FILE" ]; then \
			if [ -f "$(THEOS_PACKAGE_DIR)/$$NEW_NAME" ]; then \
				rm -f "$(THEOS_PACKAGE_DIR)/$$NEW_NAME" && \
				echo "> Đã xóa file cũ: $(THEOS_PACKAGE_DIR)/$$NEW_NAME"; \
			fi; \
			mv -f "$$PACKAGE_FILE" "$(THEOS_PACKAGE_DIR)/$$NEW_NAME" && \
			echo -e "\033[32m==> Đổi tên thành công $$NEW_NAME ở $(THEOS_PACKAGE_DIR)/\033[0m"; \
		else \
			echo "> Thất bại: không tìm thấy file .deb mới tạo trong $(THEOS_PACKAGE_DIR)/"; \
			exit 1; \
		fi; \
	else \
		echo "> Thất bại: SCHEME không được định nghĩa."; \
		exit 1; \
	fi
