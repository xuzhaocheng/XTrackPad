//
//  Settings.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import "Settings.h"
#import <UIKit/UIKit.h>

@interface Settings()

@property (nonatomic, readonly) NSUserDefaults *userDefaults;

@property (nonatomic, assign) double cursorSpeed;
@property (nonatomic, assign) BOOL keepAwake;

@end

static NSString * const kCursorSpeed = @"CursorSpeed";
static NSString * const kMaxCursorSpeed = @"MaxCursorSpeed";
static NSString * const kMinCursorSpeed = @"MinCursorSpeed";

static NSString * const kKeepAwake = @"KeepAwake";

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
        self.keepAwake = [self.userDefaults boolForKey:kKeepAwake];
    }
    return self;
}

+ (void)registerDefaults {
    NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultPreferences" withExtension:@"plist"];
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
}

+ (double)minCursorSpeed {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kMinCursorSpeed];
}

+ (double)maxCursorSpeed {
    return  [[NSUserDefaults standardUserDefaults] doubleForKey:kMaxCursorSpeed];
}

+ (double)cursorSpeed {
    return [[self sharedInstance] cursorSpeed];
}

+ (void)setCursorSpeed:(double)cursorSpeed {
    [[self sharedInstance] setCursorSpeed:cursorSpeed];
}

+ (BOOL)keepAwake {
    return [[self sharedInstance] keepAwake];
}

+ (void)setKeepAwake:(BOOL)keepAwake {
    [[self sharedInstance] setKeepAwake:keepAwake];
}

- (void)setCursorSpeed:(double)cursorSpeed {
    if (cursorSpeed < [Settings minCursorSpeed] || cursorSpeed > [Settings maxCursorSpeed]) {
        return;
    }
    _cursorSpeed = cursorSpeed;
    [self.userDefaults setDouble:_cursorSpeed forKey:kCursorSpeed];
    [self.userDefaults synchronize];
}

- (void)setKeepAwake:(BOOL)keepAwake {
    _keepAwake = keepAwake;
    [[UIApplication sharedApplication] setIdleTimerDisabled:_keepAwake];
    [self.userDefaults setBool:_keepAwake forKey:kKeepAwake];
    [self.userDefaults synchronize];
}

@end
