#import <UIKit/UIKit.h>
#import "daynightwall.h"
#import "GcUniversal/GcImagePickerUtils.h"

@interface CSCoverSheetViewController : UIViewController 
	
@end

%group daynightwall
	
	%hook CSCoverSheetViewController
	
		- (void) viewDidLoad {

			%orig;

			wallpaperImageViewLS = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
			
			[wallpaperImageViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        	[wallpaperImageViewLS setContentMode:UIViewContentModeScaleAspectFill];
        	[wallpaperImageViewLS setClipsToBounds:YES];
			[[self view] insertSubview:wallpaperImageViewLS atIndex:0];

		}

	%end	

	%hook SBLockScreenManager

		//only check to change when locking device because who sits on the lockscreen 24/7 to see it change
		- (void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 completion:(id)arg3 { 

			%orig;

			NSDate *currentTime = [NSDate date];
			NSDateFormatter *formatTime = [[NSDateFormatter alloc] init];
			[formatTime setDateFormat:@"HH"];
			NSString *dateString = [formatTime stringFromDate:currentTime];

			if ([dateString intValue] >= 22) {
				wallpaperMidnight = [GcImagePickerUtils imageFromDefaults:@"com.denial.daynightwallprefs" withKey:@"wallpaperMidnight"];
				[wallpaperImageViewLS setImage:wallpaperMidnight];
			} else if ([dateString intValue] >= 18) {
				wallpaperSunset = [GcImagePickerUtils imageFromDefaults:@"com.denial.daynightwallprefs" withKey:@"wallpaperSunset"];
				[wallpaperImageViewLS setImage:wallpaperSunset];
			} else if ([dateString intValue] >= 12) {
				wallpaperAfternoon = [GcImagePickerUtils imageFromDefaults:@"com.denial.daynightwallprefs" withKey:@"wallpaperAfternoon"];
				[wallpaperImageViewLS setImage:wallpaperAfternoon];
			} else if ([dateString intValue] >= 8) {
				wallpaperMorning = [GcImagePickerUtils imageFromDefaults:@"com.denial.daynightwallprefs" withKey:@"wallpaperMorning"];
				[wallpaperImageViewLS setImage:wallpaperMorning];
			}

		}	
	
	%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"com.denial.daynightwallprefs"];

	[preferences registerBool:&tweakEnabled default:NO forKey:@"tweakEnabled"];

	if (tweakEnabled) {
		%init(daynightwall)
	}

}