//
//  TrackModeDrag.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import "TrackModeDrag.h"
#import "ClientConnectionManager.h"
#import "MouseEvent.h"

@implementation TrackModeDrag

- (TrackModeType)type {
    return TrackModeTypeDrag;
}

- (void)enter {
#if DEBUG_TRACK_MODE
    NSLog(@"Enter drag track mode");
#endif
    MouseEvent *event = [[MouseEvent alloc] init];
    event.type = MouseEventTypeBeginDrag;
    [ClientConnectionManager sendEvent:event];
}

- (void)leave {
#if DEBUG_TRACK_MODE
    NSLog(@"Leave drag track mode");
#endif
    MouseEvent *event = [[MouseEvent alloc] init];
    event.type = MouseEventTypeEndDrag;
    [ClientConnectionManager sendEvent:event];
}

- (BOOL)couldTransformTo:(id<TrackMode>)mode {
    switch (mode.type) {
        case TrackModeTypeMove:
        case TrackModeTypeScroll:
        case TrackModeTypeDrag:
            return NO;
        default:
            return YES;
    }
}

@end
