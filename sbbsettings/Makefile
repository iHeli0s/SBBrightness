include ../framework/makefiles/common.mk

BUNDLE_NAME = sbbsettings
sbbsettings_FILES = sbbsettings.mm
sbbsettings_INSTALL_PATH = /Library/PreferenceBundles
sbbsettings_FRAMEWORKS = UIKit
sbbsettings_PRIVATE_FRAMEWORKS = Preferences

include ../framework/makefiles/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/sbbsettings.plist$(ECHO_END)
