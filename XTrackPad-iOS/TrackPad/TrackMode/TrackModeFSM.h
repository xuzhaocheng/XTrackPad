//
//  TrackModeFSM.h
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import <Foundation/Foundation.h>
#import "TrackMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrackModeFSM : NSObject

@property (nonatomic, strong) id<TrackMode> curMode;

- (void)accpetTouchCount:(NSInteger)count;
- (void)setTrackModeWithTouchCount:(NSInteger)count;
- (void)reset;

@end

NS_ASSUME_NONNULL_END
