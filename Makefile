export THEOS_DEVICE_IP=192.168.178.38
export SDKROOT=iphoneos
export SYSROOT=$(THEOS)/sdks/iPhoneOS11.2.sdk
export PACKAGE_VERSION=0.2

ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ProudLock
ProudLock_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += proudlock
include $(THEOS_MAKE_PATH)/aggregate.mk
