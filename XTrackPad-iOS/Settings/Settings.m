//
//  Settings.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import "Settings.h"

@interface Settings()
@property (nonatomic, readonly) NSUserDefaults *userDefaults;
@end

static NSString * const kCursorSpeed = @"CursorSpeed";
static NSString * const kMaxCursorSpeed = @"MaxCursorSpeed";
static NSString * const kMinCursorSpeed = @"MinCursorSpeed";

@implementation Settings

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static Settings *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[Settings alloc] init];
    });
    return _instance;
}

- (NSUserDefaults *)userDefaults {
    return [NSUserDefaults standardUserDefaults];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cursorSpeed = [self.userDefaults doubleForKey:kCursorSpeed];
    }
    return self;
}

+ (void)registerDefaults {
    NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultPreferences" withExtension:@"plist"];
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
}

- (void)setCursorSpeed:(double)cursorSpeed {
    if (cursorSpeed < [Settings minCursorSpeed] || cursorSpeed > [Settings maxCursorSpeed]) {
        return;
    }
    _cursorSpeed = cursorSpeed;
    [self.userDefaults setDouble:_cursorSpeed forKey:kCursorSpeed];
    [self.userDefaults synchronize];
}

+ (double)minCursorSpeed {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kMinCursorSpeed];
}

+ (double)maxCursorSpeed {
    return  [[NSUserDefaults standardUserDefaults] doubleForKey:kMaxCursorSpeed];
}

@end
