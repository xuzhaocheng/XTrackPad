//
//  PeerTalkClient.m
//  VTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import "PeerTalkClient.h"
#import "PTChannel.h"
#import "MouseEvent.h"
#import "Defines.h"

@interface PeerTalkClient() <PTChannelDelegate>

@property (nonatomic, weak) PTChannel *serverChannel;
@property (nonatomic, weak) PTChannel *peerChannel;

@end

@implementation PeerTalkClient

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static PeerTalkClient *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[PeerTalkClient alloc] init];
    });
    return _instance;
}

- (void)startup {
    PTChannel *channel = [PTChannel channelWithDelegate:self];
    [channel listenOnPort:PTProtocolIPv4Port IPv4Address:INADDR_LOOPBACK callback:^(NSError *error) {
        if (error) {
            NSLog(@"");
        } else {
            self.serverChannel = channel;
        }
    }];
}

- (ConnectionState)connectionState {
    if (self.peerChannel) {
        return ConnectionStateConnected;
    }
    return ConnectionStateNotConnected;
}

- (void)sendEvent:(MouseEvent *)event {
    if (self.peerChannel) {
        dispatch_data_t payload = [event payload];
        [self.peerChannel sendFrameOfType:PTFrameTypeEvent tag:PTFrameNoTag withPayload:(NSData *)payload callback:^(NSError *error) {
            if (error) {
                NSLog(@"Failed to send message: %@", error);
            }
        }];
    } else {
        NSLog(@"Can not send message — not connected");
    }
}

#pragma mark - PTChannelDelegate
// Invoked to accept an incoming frame on a channel. Reply NO ignore the
// incoming frame. If not implemented by the delegate, all frames are accepted.
- (BOOL)ioFrameChannel:(PTChannel*)channel shouldAcceptFrameOfType:(uint32_t)type tag:(uint32_t)tag payloadSize:(uint32_t)payloadSize {
    if (channel != self.peerChannel) {
        // A previous channel that has been canceled but not yet ended. Ignore.
        return NO;
    } else if (type != PTFrameTypeEvent) {
        NSLog(@"Unexpected frame of type %u", type);
        [channel close];
        self.peerChannel = nil;
        [self.delegate connectionStatusDidChange];
        return NO;
    } else {
        return YES;
    }
}

// Invoked when a new frame has arrived on a channel.
- (void)ioFrameChannel:(PTChannel*)channel didReceiveFrameOfType:(uint32_t)type tag:(uint32_t)tag payload:(NSData *)payload {

}

// Invoked when the channel closed. If it closed because of an error, *error* is
// a non-nil NSError object.
- (void)ioFrameChannel:(PTChannel*)channel didEndWithError:(NSError*)error {
    if (error) {
        NSLog(@"%@ ended with error: %@", channel, error);
    } else {
        self.peerChannel = nil;
        [self.delegate connectionStatusDidChange];
        NSLog(@"Disconnected from %@", channel.userInfo);
    }
}

// For listening channels, this method is invoked when a new connection has been
// accepted.
- (void)ioFrameChannel:(PTChannel*)channel didAcceptConnection:(PTChannel*)otherChannel fromAddress:(PTAddress*)address {
    // Cancel any other connection. We are FIFO, so the last connection
    // established will cancel any previous connection and "take its place".
    if (self.peerChannel) {
        [self.peerChannel cancel];
    }

    // Weak pointer to current connection. Connection objects live by themselves
    // (owned by its parent dispatch queue) until they are closed.
    self.peerChannel = otherChannel;
    self.peerChannel.userInfo = address;
    NSLog(@"Connected to %@", address);
    [self.delegate connectionStatusDidChange];
    // Send some information about ourselves to the other end

}

@end

