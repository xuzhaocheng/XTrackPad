//
//  TrackModeScroll.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import "TrackModeScroll.h"

@implementation TrackModeScroll

- (TrackModeType)type {
    return TrackModeTypeScroll;
}

- (void)enter {
#if DEBUG_TRACK_MODE
    NSLog(@"Enter scroll track mode");
#endif
}

- (void)leave {
#if DEBUG_TRACK_MODE
    NSLog(@"Leave scroll track mode");
#endif
}

- (BOOL)couldTransformTo:(id<TrackMode>)mode {
    switch (mode.type) {
        case TrackModeTypeScroll:
        case TrackModeTypeMove:
            return NO;
        default:
            return YES;
    }
}


@end
