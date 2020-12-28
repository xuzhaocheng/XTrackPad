//
//  PeerTalkClient.h
//  VTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import <Foundation/Foundation.h>
#import "EventTypes.h"
#import "APIClientProtocol.h"

@class MouseEvent;

NS_ASSUME_NONNULL_BEGIN

@interface PeerTalkClient : NSObject <APIClientProtocol>

+ (instancetype)sharedInstance;
- (void)startup;
- (void)sendEvent:(MouseEvent *)event;

@end

NS_ASSUME_NONNULL_END
