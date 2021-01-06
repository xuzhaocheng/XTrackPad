//
//  ServerConnectionManager.m
//  XTrackPad-macOS
//
//  Created by xuzhaocheng on 2021/1/5.
//

#import "ServerConnectionManager.h"

@interface ServerConnectionManager() <ConnectionStateListener>

@property (nonatomic, strong) NSMutableArray<id<ServerProtocol>> *serverList;

@end

@implementation ServerConnectionManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ServerConnectionManager *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[ServerConnectionManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _serverList = [NSMutableArray array];
    }
    return self;
}

- (void)registerServer:(id<ServerProtocol>)server {
    if (![self.serverList containsObject:server]) {
        [server setDelegate:self];
        [self.serverList addObject:server];
    }
}

- (void)startup {
    for (id<ServerProtocol> server in self.serverList) {
        [server start];
    }
}

- (void)stopAllServers {
    for (id<ServerProtocol> server in self.serverList) {
        [server stop];
    }
}

- (void)connectionStatusDidChange:(id<ServerProtocol>)server {
    [self.delegate connectionStatusDidChange:server];
}

@end
