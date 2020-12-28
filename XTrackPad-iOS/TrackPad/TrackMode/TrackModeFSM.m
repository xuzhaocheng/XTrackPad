//
//  TrackModeFSM.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import "TrackModeFSM.h"
#import "TrackModeNone.h"
#import "TrackModeMove.h"
#import "TrackModeScroll.h"
#import "TrackModeDrag.h"

@implementation TrackModeFSM

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.curMode = [[TrackModeNone alloc] init];
    }
    return self;
}

- (id<TrackMode>)trackModeWithTouchCount:(NSInteger)count {
    switch (count) {
        case 1:
            return [[TrackModeMove alloc] init];
        case 2:
            return [[TrackModeScroll alloc] init];
        case 3:
            return [[TrackModeDrag alloc] init];
        default:
            return [[TrackModeNone alloc] init];
    }
}

- (void)setTrackModeWithTouchCount:(NSInteger)count {
    id<TrackMode> next = [self trackModeWithTouchCount:count];
    [self.curMode leave];
    self.curMode = next;
    [self.curMode enter];
}

- (void)accpetTouchCount:(NSInteger)count {
    id<TrackMode> next = [self trackModeWithTouchCount:count];
    if ([self.curMode couldTransformTo:next]) {
        [self.curMode leave];
        self.curMode = next;
        [self.curMode enter];
    }
}

- (void)reset {
    TrackModeNone *none = [[TrackModeNone alloc] init];
    [self.curMode leave];
    self.curMode = none;
    [self.curMode enter];
}

@end
