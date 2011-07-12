#import <Preferences/Preferences.h>

@interface sbbsettingsListController: PSListController {
}
@end

@implementation sbbsettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"sbbsettings" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
