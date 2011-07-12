#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBBrightnessController.h>
#import <SpringBoard/SBSearchController.h>
#import <SpringBoard/SBAppSwitcherController.h>

#define PREFSPATH @"/var/mobile/Library/Preferences/com.fr0zensun.sbbrightness.plist"

@class SBBrightnessController;
@class SBUIController;
UISlider *slider;


%hook PSRootController
%new(v@:)
-(void)_SBBOpenTwitter{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://twitter.com/fr0zensun"]];


}
%end
%hook SBUIController
-(void)finishLaunching {

slider = [[UISlider alloc]init];
slider.frame = CGRectMake(10,380,300,30);


slider.minimumValueImage = [UIImage imageWithContentsOfFile:@"/Applications/Preferences.app/LessBright.png"];
slider.maximumValueImage = [UIImage imageWithContentsOfFile:@"/Applications/Preferences.app/MoreBright.png"];
slider.minimumValue = 0;
slider.maximumValue = 1.0;
slider.continuous = YES;

slider.backgroundColor = [UIColor clearColor];
[slider addTarget:self action:@selector(changeBrightness) forControlEvents:UIControlEventValueChanged];

[[self window]addSubview:slider];



}

%new(v@:@@)
-(void)changeBrightness {
%class SBBrightnessController;
id controller = [$SBBrightnessController sharedBrightnessController];
NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:PREFSPATH];
if ([[dict objectForKey:@"showHUD"] boolValue])
{
[controller _setBrightnessLevel:slider.value showHUD:YES];
}
else {
[controller setBrightnessLevel:slider.value];
}
}


%end
%hook SBBrightnessController
- (void)_setBrightnessLevel:(float)arg1 showHUD:(BOOL)arg2 {
slider.value = arg1;
%orig;

}
- (void)setBrightnessLevel:(float)arg1 {

slider.value = arg1;
%orig;

}


%end
%hook SBSearchController
-(void)searchBarTextDidBeginEditing:(id)searchBarText {

[slider removeFromSuperview];

%orig;

}
-(void)searchBarTextDidEndEditing:(id)searchBarText {
%class SBUIController;
id controller = [$SBUIController sharedInstance];

[[controller window]addSubview:slider];

%orig;

}

%end
%hook SBAppSwitcherController
-(void)viewWillAppear {

[slider removeFromSuperview];

%orig;
}
-(void)appSwitcherBarRemovedFromSuperview:(id)superview {
%class SBUIController;

id controller = [$SBUIController sharedInstance];

[[controller window]addSubview:slider];

%orig;
}


%end

