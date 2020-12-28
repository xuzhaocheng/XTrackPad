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
    NSLog(@"Enter scroll track mode");
}

- (void)leave {
    NSLog(@"Leave scroll track mode");
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
