#import "daynightwall.h"
//#import "GcUniversal/GcImagePickerUtils.h"
#import "GcImagePickerUtils.h"

@interface CSCoverSheetViewController : UIViewController 
	- (void)updateWallpaper;
	- (void)createWallpaper;
@end



static void loadPrefsInAFancyWay() {

	// convert an unmutable dictionary into a mutable one. I don't have a single clue
	// as to why, but it works lmao

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];


	tweakEnabled = prefs[@"tweakEnabled"] ? [prefs[@"tweakEnabled"] boolValue] : NO;

}
	
	%hook CSCoverSheetViewController


	%new


		- (void)createWallpaper {


			loadPrefsInAFancyWay();

			// give it a tag and remove from superview, otherwise, the tweak enables on the fly, but doesn't disable
			// because the image it's still there

			[[self.view viewWithTag:120] removeFromSuperview];

			if(tweakEnabled) {

				wallpaperImageViewLS = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
			
				[wallpaperImageViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        		[wallpaperImageViewLS setContentMode:UIViewContentModeScaleAspectFill];
        		[wallpaperImageViewLS setClipsToBounds:YES];
        		wallpaperImageViewLS.tag = 120;
				[[self view] insertSubview:wallpaperImageViewLS atIndex:0];

			}

		}


		- (void)viewWillAppear:(BOOL)animated {

			%orig;

			[self createWallpaper];
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

%ctor {

	loadPrefsInAFancyWay();

}