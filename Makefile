THEOS_PACKAGE_DIR_NAME = debs
TARGET = :clang
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = Homepaper
Homepaper_FILES = Homepaper.xm
Homepaper_FRAMEWORKS = UIKit
Homepaper_PRIVATE_FRAMEWORKS = Preferences PhotoLibrary

include $(THEOS_MAKE_PATH)/tweak.mk

internal-after-install::
	install.exec "killall -9 backboardd"