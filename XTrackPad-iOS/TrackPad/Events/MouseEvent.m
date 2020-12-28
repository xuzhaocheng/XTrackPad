//
//  MouseEvent.m
//  VTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import "MouseEvent.h"

@implementation MouseEvent

- (dispatch_data_t)payload {
    PTEventFrame *frame = CFAllocatorAllocate(nil, sizeof(PTEventFrame), 0);

    frame->type = self.type;
    frame->x = self.delta.x;
    frame->y = self.delta.y;

    return dispatch_data_create((const void*)frame, sizeof(PTEventFrame), nil, ^{
        CFAllocatorDeallocate(nil, frame);
    });
}
@end
