//
//  Settings.h
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Settings : NSObject

+ (void)registerDefaults;
+ (double)maxCursorSpeed;
+ (double)minCursorSpeed;

+ (double)cursorSpeed;
+ (void)setCursorSpeed:(double)cursorSpeed;

+ (BOOL)keepAwake;
+ (void)setKeepAwake:(BOOL)keepAwake;

@end

NS_ASSUME_NONNULL_END
