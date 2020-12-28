//
//  PeerTalkAPIServer.m
//  VTrackPad
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import "PeerTalkServer.h"
#import "Peertalk.h"
#import "Defines.h"
#import "PeerTalkFrameProcessor.h"

enum PTFrameType {
    PTFrameTypeEvent = 1001,
};

@interface PeerTalkServer() <PTChannelDelegate>

@property (nonatomic, assign) NSNumber *connectingToDeviceID;
@property (nonatomic, assign) NSNumber *connectedDeviceID;
@property (nonatomic, strong) NSDictionary *connectedDeviceProperties;
@property (nonatomic, strong) NSDictionary *remoteDeviceInfo;
@property (nonatomic, strong) dispatch_queue_t notConnectedQueue;
@property (nonatomic, assign) BOOL notConnectedQueueSuspended;
@property (nonatomic, strong) NSTimer *retryTimer;

@property(nonatomic, strong) PTChannel *connectedChannel;
@end

static const int PTProtocolIPv4Port = 2345;
static const NSTimeInterval PTAppReconnectDelay = 3.0;


@implementation PeerTalkServer

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static PeerTalkServer *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[PeerTalkServer alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.notConnectedQueue = dispatch_queue_create("XTrackPad.notConnectedQueue", DISPATCH_QUEUE_SERIAL);
        self.retryTimer = [NSTimer timerWithTimeInterval:PTAppReconnectDelay target:self selector:@selector(tryToConnect) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.retryTimer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)startup {
    [self startListeningForDevices];
//    [self enqueueConnectToLocalIPv4Port];
}

- (void)tryToConnect {
    dispatch_async(self.notConnectedQueue, ^{
        if (!self.connectingToDeviceID) return;
        if (self.connectedDeviceID) return;
        [self enqueueConnectToUSBDevice];
    });
}

#pragma mark - PTChannelDelegate

- (BOOL)ioFrameChannel:(PTChannel*)channel shouldAcceptFrameOfType:(uint32_t)type tag:(uint32_t)tag payloadSize:(uint32_t)payloadSize {
    if (type != PTFrameTypeEvent) {
        NSLog(@"Unexpected frame of type %u", type);
        [channel close];
        return NO;
    } else {
        return YES;
    }
}

- (void)ioFrameChannel:(PTChannel*)channel didReceiveFrameOfType:(uint32_t)type tag:(uint32_t)tag payload:(NSData *)payload {

    if (type != PTFrameTypeEvent) {
        NSLog(@"unsupported frame type");
        return;
    }

    PTEventFrame *frame = (PTEventFrame *)payload.bytes;

    [PeerTalkFrameProcessor handle:frame];
}

- (void)ioFrameChannel:(PTChannel*)channel didEndWithError:(NSError*)error {
    if (self.connectedDeviceID && [self.connectedDeviceID isEqualToNumber:channel.userInfo]) {
        [self didDisconnectFromDevice:self.connectedDeviceID];
    }

    if (self.connectedChannel == channel) {
        NSLog(@"Disconnected from %@", channel.userInfo);
        self.connectedChannel = nil;
    }
}

#pragma mark - Wired device connections

- (void)startListeningForDevices {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc addObserverForName:PTUSBDeviceDidAttachNotification object:PTUSBHub.sharedHub queue:nil usingBlock:^(NSNotification *note) {
        NSNumber *deviceID = [note.userInfo objectForKey:PTUSBHubNotificationKeyDeviceID];

        NSLog(@"PTUSBDeviceDidAttachNotification: %@", deviceID);

        dispatch_async(self.notConnectedQueue, ^{
            if (!self.connectingToDeviceID || ![deviceID isEqualToNumber:self.connectingToDeviceID]) {
                [self disconnectFromCurrentChannel];
                self.connectingToDeviceID = deviceID;
                self.connectedDeviceProperties = [note.userInfo objectForKey:PTUSBHubNotificationKeyProperties];
                [self enqueueConnectToUSBDevice];
            }
        });
    }];

    [nc addObserverForName:PTUSBDeviceDidDetachNotification object:PTUSBHub.sharedHub queue:nil usingBlock:^(NSNotification *note) {
        NSNumber *deviceID = [note.userInfo objectForKey:PTUSBHubNotificationKeyDeviceID];
        //NSLog(@"PTUSBDeviceDidDetachNotification: %@", note.userInfo);
        NSLog(@"PTUSBDeviceDidDetachNotification: %@", deviceID);

        if ([self.connectingToDeviceID isEqualToNumber:deviceID]) {
            self.connectedDeviceProperties = nil;
            self.connectingToDeviceID = nil;
            if (self.connectedChannel) {
                [self.connectedChannel close];
            }
        }
    }];
}

- (void)didDisconnectFromDevice:(NSNumber*)deviceID {
    NSLog(@"Disconnected from device");
    if ([self.connectedDeviceID isEqualToNumber:deviceID]) {
        [self willChangeValueForKey:@"connectedDeviceID"];
        self.connectedDeviceID = nil;
        [self didChangeValueForKey:@"connectedDeviceID"];
    }
}

- (void)disconnectFromCurrentChannel {
    if (self.connectedDeviceID && self.connectedChannel) {
        [self.connectedChannel close];
        self.connectedChannel = nil;
    }
}

/*
- (void)enqueueConnectToLocalIPv4Port {
    dispatch_async(self.notConnectedQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self connectToLocalIPv4Port];
        });
    });
}


- (void)connectToLocalIPv4Port {
    PTChannel *channel = [PTChannel channelWithDelegate:self];
    channel.userInfo = [NSString stringWithFormat:@"127.0.0.1:%d", PTProtocolIPv4Port];
    [channel connectToPort:PTProtocolIPv4Port IPv4Address:INADDR_LOOPBACK callback:^(NSError *error, PTAddress *address) {
        if (error) {
            if (error.domain == NSPOSIXErrorDomain && (error.code == ECONNREFUSED || error.code == ETIMEDOUT)) {
                // this is an expected state
            } else {
                NSLog(@"Failed to connect to 127.0.0.1:%d: %@", PTProtocolIPv4Port, error);
            }
        } else {
            [self disconnectFromCurrentChannel];
            self.connectedChannel = channel;
            channel.userInfo = address;
            NSLog(@"Connected to %@", address);
        }
        [self performSelector:@selector(enqueueConnectToLocalIPv4Port) withObject:nil afterDelay:PTAppReconnectDelay];
    }];
}
*/

- (void)enqueueConnectToUSBDevice {
    dispatch_async(self.notConnectedQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self connectToUSBDevice];
        });
    });
}


- (void)connectToUSBDevice {
    PTChannel *channel = [PTChannel channelWithDelegate:self];
    channel.userInfo = self.connectingToDeviceID;
    channel.delegate = self;

    [channel connectToPort:PTProtocolIPv4Port overUSBHub:PTUSBHub.sharedHub deviceID:self.connectingToDeviceID callback:^(NSError *error) {
        if (error) {
            if (error.domain == PTUSBHubErrorDomain && error.code == PTUSBHubErrorConnectionRefused) {
                NSLog(@"Failed to connect to device #%@: %@", channel.userInfo, error);
            } else {
                NSLog(@"Failed to connect to device #%@: %@", channel.userInfo, error);
            }
//            if (channel.userInfo == self.connectingToDeviceID) {
//                [self performSelector:@selector(enqueueConnectToUSBDevice) withObject:nil afterDelay:PTAppReconnectDelay];
//            }
        } else {
            NSLog(@"Connected to device: %@", self.connectingToDeviceID);
            self.connectedDeviceID = self.connectingToDeviceID;
            self.connectedChannel = channel;
        }
    }];
}

@end
