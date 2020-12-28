//
//  AppDelegate.m
//  XTrackPad
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import "AppDelegate.h"
#import "PeerTalkServer.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [[PeerTalkServer sharedInstance] startup];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
