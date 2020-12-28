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
    NSLog(@"Enter move track mode");
}

- (void)leave {
    NSLog(@"Leave move track mode");
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
