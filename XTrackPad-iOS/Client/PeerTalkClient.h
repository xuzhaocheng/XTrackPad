//
//  PeerTalkClient.h
//  VTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import <Foundation/Foundation.h>
#import "EventTypes.h"
#import "ClientProtocol.h"

@class MouseEvent;

NS_ASSUME_NONNULL_BEGIN

@interface PeerTalkClient : NSObject <ClientProtocol>

@property (nonatomic, weak) id <ConnectionStateListener> delegate;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
