//
//  Mouse.h
//  VTrackPad
//
//  Created by xuzhaocheng on 2020/12/25.
//

#import <Foundation/Foundation.h>
@import AppKit;
NS_ASSUME_NONNULL_BEGIN

@interface Mouse : NSObject

+ (instancetype)sharedInstance;

+ (void)move:(CGPoint)delta;
+ (void)up;
+ (void)down;
+ (void)singleClick;
+ (void)doubleClick;
+ (void)scroll:(CGPoint)delta;
+ (void)rightClick;
+ (void)beginDrag;
+ (void)drag:(CGPoint)delta;
+ (void)endDrag;

@end

NS_ASSUME_NONNULL_END
