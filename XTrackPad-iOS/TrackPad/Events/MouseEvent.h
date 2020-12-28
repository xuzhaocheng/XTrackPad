//
//  MouseEvent.h
//  VTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import <Foundation/Foundation.h>
#import "EventTypes.h"
#import "Defines.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MouseEvent : NSObject <PeerTalkData>

@property (nonatomic, assign) MouseEventType type;
@property (nonatomic, assign) CGPoint delta;

@end

NS_ASSUME_NONNULL_END
