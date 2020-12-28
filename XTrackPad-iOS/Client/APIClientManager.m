//
//  APIClientManager.m
//  VTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import "APIClientManager.h"
#import "PeerTalkClient.h"

@implementation APIClientManager

+ (id<APIClientProtocol>)activeClient {
//    return nil;
    return [PeerTalkClient sharedInstance];
}

@end
