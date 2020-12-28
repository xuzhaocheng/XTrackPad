//
//  APIClientManager.h
//  VTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import <Foundation/Foundation.h>
#import "APIClientProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIClientManager : NSObject
+ (id<APIClientProtocol>)activeClient;
@end

NS_ASSUME_NONNULL_END
