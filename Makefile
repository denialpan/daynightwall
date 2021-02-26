export ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:10.3
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = daynightwall

daynightwall_FILES = Tweak.xm
daynightwall_CFLAGS = -fobjc-arc
daynightwall_FRAMEWORKS = UIKit AudioToolbox
daynightwall_EXTRA_FRAMEWORKS += Cephei 
daynightwall_LIBRARIES = gcuniversal

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += daynightwallprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
