//
//  ConnectionManager.m
//  VTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import "ConnectionManager.h"
#import "PeerTalkClient.h"
#import <UIKit/UIKit.h>

NSNotificationName const XTPConnectionStatusDidChange = @"XTPConnectionStatusDidChange";

@interface ConnectionManager () <ConnectionStateListener>

@end

@implementation ConnectionManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ConnectionManager * _instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[ConnectionManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [PeerTalkClient sharedInstance].delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillResume:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (id<ClientProtocol>)activeClient {
    return [PeerTalkClient sharedInstance];
}

- (void)connectionStatusDidChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:XTPConnectionStatusDidChange object:nil];
}

- (void)appWillResume:(NSNotification *)notification {
    if ([ConnectionManager connectionState] != ConnectionStateConnected) {
        [[ConnectionManager activeClient] connect];
    }
}

#pragma mark - Public Methods

+ (void)startup {
    [self sharedInstance];
    [[self activeClient] connect];
}

+ (ConnectionState)connectionState {
    return [[self activeClient] connectionState];
}

+ (void)sendEvent:(MouseEvent *)event {
    [[self activeClient] sendEvent:event];
}


@end
