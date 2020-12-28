//
//  Settings.h
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Settings : NSObject

@property (nonatomic, assign) double cursorSpeed;

+ (instancetype)sharedInstance;
+ (void)registerDefaults;
+ (double)maxCursorSpeed;
+ (double)minCursorSpeed;

@end

NS_ASSUME_NONNULL_END
