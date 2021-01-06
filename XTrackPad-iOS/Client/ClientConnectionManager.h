//
//  ClientConnectionManager.h
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import <Foundation/Foundation.h>
#import "ClientProtocol.h"

NS_ASSUME_NONNULL_BEGIN

extern NSNotificationName const XTPConnectionStatusDidChange;

@interface ClientConnectionManager : NSObject

+ (void)startup;
+ (void)sendEvent:(MouseEvent *)event;
+ (ConnectionState)connectionState;

@end

NS_ASSUME_NONNULL_END
