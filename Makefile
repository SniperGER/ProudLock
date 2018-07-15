export PACKAGE_VERSION=0.1
export SDKROOT=iphoneos

ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ProudLock
ProudLock_FILES = Tweak.xm
ProudLock_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
