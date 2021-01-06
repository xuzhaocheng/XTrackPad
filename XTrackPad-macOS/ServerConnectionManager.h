//
//  ServerConnectionManager.h
//  XTrackPad-macOS
//
//  Created by xuzhaocheng on 2021/1/5.
//

#import <Foundation/Foundation.h>
#import "ServerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServerConnectionManager : NSObject

@property (nonatomic, weak) id<ConnectionStateListener> delegate;

+ (instancetype)sharedInstance;

- (void)registerServer:(id<ServerProtocol>)server;
- (void)startup;
- (void)stopAllServers;

@end

NS_ASSUME_NONNULL_END
