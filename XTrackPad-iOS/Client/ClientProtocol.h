//
//  ClientProtocol.h
//  VTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import <Foundation/Foundation.h>

@class MouseEvent;

typedef enum : NSUInteger {
    ConnectionStateConnecting,
    ConnectionStateConnected,
    ConnectionStateNotConnected,
} ConnectionState;

NS_ASSUME_NONNULL_BEGIN

@protocol ClientProtocol <NSObject>

- (void)startup;
- (ConnectionState)connectionState;
- (void)sendEvent:(MouseEvent *)event;

@end

@protocol ConnectionStateListener <NSObject>

- (void)connectionStatusDidChange;

@end

NS_ASSUME_NONNULL_END
