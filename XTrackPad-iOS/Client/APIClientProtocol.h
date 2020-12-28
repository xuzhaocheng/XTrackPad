//
//  APIClientProtocol.h
//  VTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import <Foundation/Foundation.h>

@class MouseEvent;

NS_ASSUME_NONNULL_BEGIN

@protocol APIClientProtocol <NSObject>

- (void)startup;
- (void)sendEvent:(MouseEvent *)event;

@end

NS_ASSUME_NONNULL_END
