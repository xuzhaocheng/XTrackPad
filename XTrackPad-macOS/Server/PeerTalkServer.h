//
//  PeerTalkServer.h
//  VTrackPad
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import <Foundation/Foundation.h>
#import "ServerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PeerTalkServer : NSObject <ServerProtocol>

@property (nonatomic, weak) id<ConnectionStateListener> delegate;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
