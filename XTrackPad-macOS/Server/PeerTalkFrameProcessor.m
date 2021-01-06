//
//  PeerTalkFrameHandler.m
//  VTrackPad
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import "PeerTalkFrameProcessor.h"
#import "Mouse.h"

@implementation PeerTalkFrameProcessor

+ (void)handle:(PTEventFrame *)frame {
    NSLog(@"handle %d", frame->type);
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (frame->type) {
            case MouseEventTypeMove:
                [Mouse move:CGPointMake(frame->x, frame->y)];
                break;
            case MouseEventTypeSingleClick:
                [Mouse singleClick];
                break;
            case MouseEventTypeDoubleClick:
                [Mouse doubleClick];
                break;
            case MouseEventTypeRightClick:
                [Mouse rightClick];
                break;;
            case MouseEventTypeScroll:
                [Mouse scroll:CGPointMake(frame->x, frame->y)];
                break;
            case MouseEventTypeBeginDrag:
                [Mouse beginDrag];
#if DEBUG
                NSLog(@"Receive Begin Drag Event");
#endif
                break;
            case MouseEventTypeEndDrag:
                [Mouse endDrag];
#if DEBUG
                NSLog(@"Receive End Drag Event");
#endif
                break;
            default:
                break;
        }

    });
}

@end
