TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = daynightwallprefs

daynightwallprefs_FILES = $(wildcard *.m)
daynightwallprefs_FRAMEWORKS = UIKit
daynightwallprefs_LIBRARIES = gcuniversal
daynightwallprefs_PRIVATE_FRAMEWORKS = Preferences
daynightwallprefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs 
daynightwallprefs_INSTALL_PATH = /Library/PreferenceBundles
daynightwallprefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

ADDITIONAL_CFLAGS += -DTHEOS_LEAN_AND_MEAN


include $(THEOS_MAKE_PATH)/bundle.mk
