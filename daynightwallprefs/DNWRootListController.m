#include "DNWRootListController.h"
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <Cephei/HBRespringController.h>
#import <spawn.h>

HBPreferences *prefs;

@implementation DNWRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)resetPreferences {

	prefs = [[HBPreferences alloc] initWithIdentifier: @"com.denial.daynightwallprefs"];
    [prefs removeAllObjects];

    [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/Preferences/com.denial.daynightwallprefs/" error:nil];
	[self respringUtil];
	
}

- (void)respringUtil {	

	pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    [HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=DayNightWall"]];
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, NULL);
	
}

@end
