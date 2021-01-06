//
//  TrackPadActionConsumer.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/28.
//

#import "TrackPadActionConsumer.h"
#import "MouseEvent.h"
#import "Settings.h"
#import "ClientConnectionManager.h"

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
    return [Settings cursorSpeed];
}

#pragma mark - TrackPadActionConsumerProtocol

- (void)handleDoubleClickEvent { 
    self.mouseEvent.type = MouseEventTypeDoubleClick;
    [ClientConnectionManager sendEvent:self.mouseEvent];
}

- (void)handleMoveEventWithDelta:(CGPoint)delta {
    self.mouseEvent.delta = CGPointMake(delta.x * [self cursorSpeed], delta.y * [self cursorSpeed]);
    self.mouseEvent.type = MouseEventTypeMove;
    [ClientConnectionManager sendEvent:self.mouseEvent];
}

- (void)handleRightClickEvent { 
    self.mouseEvent.type = MouseEventTypeRightClick;
    [ClientConnectionManager sendEvent:self.mouseEvent];
}

- (void)handleScrollEventWithDelta:(CGPoint)delta { 
    self.mouseEvent.type = MouseEventTypeScroll;
    self.mouseEvent.delta = CGPointMake(delta.x * [self cursorSpeed], delta.y * [self cursorSpeed]);
    [ClientConnectionManager sendEvent:self.mouseEvent];
}

- (void)handleSingleClickEvent {
    self.mouseEvent.type = MouseEventTypeSingleClick;
    [ClientConnectionManager sendEvent:self.mouseEvent];
}

@end
