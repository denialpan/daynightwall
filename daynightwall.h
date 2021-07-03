#import <UIKit/UIKit.h>

static NSString *plistPath = @"/var/mobile/Library/Preferences/com.denial.daynightwallprefs.plist";

BOOL tweakEnabled;

UIImageView *wallpaperImageViewLS;
UIImage *wallpaperMorning;
UIImage *wallpaperAfternoon;
UIImage *wallpaperSunset;
UIImage *wallpaperMidnight;

NSDate *currentTime;
NSDateFormatter *formatTime;
NSString *dateString;


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end