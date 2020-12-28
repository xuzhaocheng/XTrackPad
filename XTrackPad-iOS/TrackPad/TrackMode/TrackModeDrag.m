//
//  TrackModeDrag.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import "TrackModeDrag.h"
#import "APIClientManager.h"
#import "MouseEvent.h"

@implementation TrackModeDrag

- (TrackModeType)type {
    return TrackModeTypeDrag;
}

- (void)enter {
    NSLog(@"Enter drag track mode");
    MouseEvent *event = [[MouseEvent alloc] init];
    event.type = MouseEventTypeBeginDrag;
    [[APIClientManager activeClient] sendEvent:event];
}

- (void)leave {
    NSLog(@"Leave drag track mode");
    MouseEvent *event = [[MouseEvent alloc] init];
    event.type = MouseEventTypeEndDrag;
    [[APIClientManager activeClient] sendEvent:event];
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
