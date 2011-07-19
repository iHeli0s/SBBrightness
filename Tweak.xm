#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBBrightnessController.h>
#import <SpringBoard/SBSearchController.h>
#import <SpringBoard/SBAppSwitcherController.h>
#import <SpringBoardUI/SpringBoardUI.h>

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
if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
slider.frame = CGRectMake(275,25,217,23);
UIAlertView *alert = [[UIAlertView alloc]init];
alert.message = @"UIInterfaceOrientationPortrait";
[alert addButtonWithTitle:@"Close"];
[alert show];
}
else {
UIAlertView *alert = [[UIAlertView alloc]init];
slider.frame = CGRectMake(337,25,330,23);

alert.message = @"UIInterfaceOrientationLandscape";
[alert addButtonWithTitle:@"Close"];
[alert show];
}

}
else {
slider.frame = CGRectMake(10,377,300,23);
}

slider.minimumValueImage = [UIImage imageWithContentsOfFile:@"/Applications/Preferences.app/LessBright.png"];
slider.maximumValueImage = [UIImage imageWithContentsOfFile:@"/Applications/Preferences.app/MoreBright.png"];
slider.minimumValue = 0;
slider.maximumValue = 1.0;
slider.continuous = YES;
[slider setUserInteractionEnabled:YES];

slider.backgroundColor = [UIColor clearColor];
[slider addTarget:self action:@selector(changeBrightness) forControlEvents:UIControlEventValueChanged];

[[self window]addSubview:slider];

[NSTimer scheduledTimerWithTimeInterval:.3 
	target:self 
	selector:@selector(checkBrightness) 
	userInfo:nil 
	repeats:YES];
	%orig;

}
- (void)window:(id)arg1 willRotateToInterfaceOrientation:(int)arg2 duration:(double)arg3 {


%orig;
if(arg2 == 1 || arg2 == 2)
{
slider.frame = CGRectMake(275,25,217,23);


}
else if(arg2 == 3 || arg2 == 4) {
slider.frame = CGRectMake(337,25,330,23);


}

}

%new(v@:)
-(void)checkBrightness {

NSString *filePath = @"/var/mobile/Library/Preferences/com.apple.springboard.plist";
NSDictionary* plistDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
slider.value = [[plistDictionary objectForKey:@"SBBacklightLevel2"]floatValue];

}

%new(v@:)
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
%hook SBIconController
- (void)openFolder:(id)arg1 animated:(BOOL)arg2 {
[slider removeFromSuperview];

%orig;
}
- (void)openFolder:(id)arg1 animated:(BOOL)arg2 fromSwitcher:(BOOL)arg3 {
%orig;
[slider removeFromSuperview];

}
- (void)closeFolderAnimated:(BOOL)arg1 {
%orig;
%class SBUIController;

id controller = [$SBUIController sharedInstance];

[[controller window]addSubview:slider];
}
- (void)closeFolderAnimated:(BOOL)arg1 toSwitcher:(BOOL)arg2 {
%orig;
%class SBUIController;

id controller = [$SBUIController sharedInstance];

[[controller window]addSubview:slider];
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
%hook SBIconListPageControl
- (id)initWithFrame:(CGRect)frame { [%orig release]; return nil; }
%end


