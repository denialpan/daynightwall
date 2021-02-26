#import <UIKit/UIKit.h>
#import "daynightwall.h"
#import <AudioToolbox/AudioServices.h>
#import "GcUniversal/GcImagePickerUtils.h"

@interface CSCoverSheetViewController : UIViewController 
	- (void)updateWallpaper;
@end

%group daynightwall
	
	%hook CSCoverSheetViewController
	
		- (void) viewDidLoad {

			wallpaperImageViewLS = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
			
			[wallpaperImageViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        	[wallpaperImageViewLS setContentMode:UIViewContentModeScaleAspectFill];
        	[wallpaperImageViewLS setClipsToBounds:YES];
			[[self view] insertSubview:wallpaperImageViewLS atIndex:0];

			%orig;

		}

		- (void)viewWillAppear:(BOOL)animated {

			[self updateWallpaper];

		}

	%new 

		//maybe this is better if it were to be switch cases
		- (void)updateWallpaper {

			currentTime = [NSDate date];
			dateString = [formatTime stringFromDate:currentTime];

			if ([dateString intValue] >= 22) { //10 pm
				wallpaperMidnight = [GcImagePickerUtils imageFromDefaults:@"com.denial.daynightwallprefs" withKey:@"wallpaperMidnight"];
				[wallpaperImageViewLS setImage:wallpaperMidnight];
			} else if ([dateString intValue] >= 18) { //6 pm
				wallpaperSunset = [GcImagePickerUtils imageFromDefaults:@"com.denial.daynightwallprefs" withKey:@"wallpaperSunset"];
				[wallpaperImageViewLS setImage:wallpaperSunset];
			} else if ([dateString intValue] >= 12) { //12 pm
				wallpaperAfternoon = [GcImagePickerUtils imageFromDefaults:@"com.denial.daynightwallprefs" withKey:@"wallpaperAfternoon"];
				[wallpaperImageViewLS setImage:wallpaperAfternoon];
			} else if ([dateString intValue] >= 8) { //8 am
				wallpaperMorning = [GcImagePickerUtils imageFromDefaults:@"com.denial.daynightwallprefs" withKey:@"wallpaperMorning"];
				[wallpaperImageViewLS setImage:wallpaperMorning];
			} else { //time before 8 am, so loop back to midnight wallpaper
				wallpaperMidnight = [GcImagePickerUtils imageFromDefaults:@"com.denial.daynightwallprefs" withKey:@"wallpaperMidnight"];
				[wallpaperImageViewLS setImage:wallpaperMidnight];
			}

		}

	%end	

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"com.denial.daynightwallprefs"];

	[preferences registerBool:&tweakEnabled default:NO forKey:@"tweakEnabled"];

	formatTime = [[NSDateFormatter alloc] init];
	[formatTime setDateFormat:@"HH"];

	if (tweakEnabled) {
		%init(daynightwall)
	}

}