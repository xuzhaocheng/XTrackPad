//
//  TrackModeNone.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import "TrackModeNone.h"

@implementation TrackModeNone

- (TrackModeType)type {
    return TrackModeTypeNone;
}

- (void)enter { }

- (void)leave { }

- (BOOL)couldTransformTo:(id<TrackMode>)mode {
    return YES;
}

@end
