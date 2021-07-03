#include "DNWRootListController.h"
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

static NSString *plistPath = @"/var/mobile/Library/Preferences/com.denial.daynightwallprefs.plist";


@implementation DNWRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}


- (id)readPreferenceValue:(PSSpecifier*)specifier {

    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:plistPath]];
    return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:plistPath]];
    [settings setObject:value forKey:specifier.properties[@"key"]];
    [settings writeToFile:plistPath atomically:YES];

}

@end