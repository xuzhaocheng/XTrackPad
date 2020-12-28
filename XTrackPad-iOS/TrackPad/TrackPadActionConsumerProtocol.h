//
//  TrackPadActionConsumerProtocol.h
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TrackPadActionConsumerProtocol <NSObject>

- (void)handleMoveEventWithDelta:(CGPoint)delta;

- (void)handleScrollEventWithDelta:(CGPoint)delta;

- (void)handleSingleClickEvent;

- (void)handleDoubleClickEvent;

- (void)handleRightClickEvent;


@end
