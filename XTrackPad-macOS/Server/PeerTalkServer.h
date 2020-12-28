//
//  PeerTalkServer.h
//  VTrackPad
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PeerTalkServer : NSObject

+ (instancetype)sharedInstance;
- (void)startup;

@end

NS_ASSUME_NONNULL_END
