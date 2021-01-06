//
//  ServerProtocol.h
//  XTrackPad-macOS
//
//  Created by xuzhaocheng on 2021/1/5.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ConnectionStateConnecting,
    ConnectionStateConnected,
    ConnectionStateNotConnected,
} ConnectionState;

NS_ASSUME_NONNULL_BEGIN


@protocol ConnectionStateListener <NSObject>

- (void)connectionStatusDidChange:(id)server;

@end

@protocol ServerProtocol <NSObject>

- (NSString *)identifier;
- (void)start;
- (void)stop;
- (ConnectionState)connectionState;
- (void)setDelegate:(id<ConnectionStateListener>)delegate;
- (NSString *)description;

@end


NS_ASSUME_NONNULL_END
