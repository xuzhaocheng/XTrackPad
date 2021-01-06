//
//  TrackPadActionConsumer.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/28.
//

#import "TrackPadActionConsumer.h"
#import "MouseEvent.h"
#import "Settings.h"
#import "ConnectionManager.h"

@interface TrackPadActionConsumer()

@property (nonatomic, strong) MouseEvent *mouseEvent;

@end

@implementation TrackPadActionConsumer

- (MouseEvent *)mouseEvent {
    if (!_mouseEvent) {
        _mouseEvent = [[MouseEvent alloc] init];
    }
    return _mouseEvent;
}

- (double)cursorSpeed {
    return [[Settings sharedInstance] cursorSpeed];
}

#pragma mark - TrackPadActionConsumerProtocol

- (void)handleDoubleClickEvent { 
    self.mouseEvent.type = MouseEventTypeDoubleClick;
    [ConnectionManager sendEvent:self.mouseEvent];
}

- (void)handleMoveEventWithDelta:(CGPoint)delta {
    self.mouseEvent.delta = CGPointMake(delta.x * [self cursorSpeed], delta.y * [self cursorSpeed]);
    self.mouseEvent.type = MouseEventTypeMove;
    [ConnectionManager sendEvent:self.mouseEvent];
}

- (void)handleRightClickEvent { 
    self.mouseEvent.type = MouseEventTypeRightClick;
    [ConnectionManager sendEvent:self.mouseEvent];
}

- (void)handleScrollEventWithDelta:(CGPoint)delta { 
    self.mouseEvent.type = MouseEventTypeScroll;
    self.mouseEvent.delta = CGPointMake(delta.x * [self cursorSpeed], delta.y * [self cursorSpeed]);
    [ConnectionManager sendEvent:self.mouseEvent];
}

- (void)handleSingleClickEvent {
    self.mouseEvent.type = MouseEventTypeSingleClick;
    [ConnectionManager sendEvent:self.mouseEvent];
}

@end
