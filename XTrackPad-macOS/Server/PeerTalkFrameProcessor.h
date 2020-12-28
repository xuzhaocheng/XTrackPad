//
//  PeerTalkFrameProcessor.h
//  VTrackPad
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

NS_ASSUME_NONNULL_BEGIN

@interface PeerTalkFrameProcessor : NSObject

+ (void)handle:(PTEventFrame *)frame;

@end

NS_ASSUME_NONNULL_END
