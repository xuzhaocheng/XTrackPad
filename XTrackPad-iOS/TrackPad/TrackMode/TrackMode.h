//
//  TrackModeProtocol.h
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import <Foundation/Foundation.h>

@class TrackMode;

typedef enum : NSUInteger {
    TrackModeTypeNone = 0,
    TrackModeTypeMove,
    TrackModeTypeScroll,
    TrackModeTypeDrag,
} TrackModeType;

@protocol TrackMode <NSObject>

- (TrackModeType)type;
- (void)enter;
- (void)leave;
- (BOOL)couldTransformTo:(id<TrackMode>)mode;

@end
