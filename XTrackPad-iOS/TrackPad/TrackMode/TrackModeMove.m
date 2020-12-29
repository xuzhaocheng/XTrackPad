//
//  TrackModeMove.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import "TrackModeMove.h"

@implementation TrackModeMove

- (TrackModeType)type {
    return TrackModeTypeMove;
}

- (void)enter {
#if DEBUG_TRACK_MODE
    NSLog(@"Enter move track mode");
#endif
}

- (void)leave {
#if DEBUG_TRACK_MODE
    NSLog(@"Leave move track mode");
#endif
}

- (BOOL)couldTransformTo:(id<TrackMode>)mode {
    switch (mode.type) {
        case TrackModeTypeMove:
            return NO;
        default:
            return YES;
    }
}

@end
