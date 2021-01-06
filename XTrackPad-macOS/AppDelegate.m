//
//  AppDelegate.m
//  XTrackPad
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import "AppDelegate.h"
#import "PeerTalkServer.h"
#import "ServerConnectionManager.h"

@interface AppDelegate () <NSMenuItemValidation, ConnectionStateListener>

@property (weak) IBOutlet NSMenu *menu;
@property (weak) IBOutlet NSMenuItem *stateMenuItem;

@property (nonatomic, strong) NSStatusItem *appIcon;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.appIcon.menu = self.menu;
    [self initConnectionManager];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)initConnectionManager {
    [[ServerConnectionManager sharedInstance] setDelegate:self];
    [[ServerConnectionManager sharedInstance] registerServer:[PeerTalkServer sharedInstance]];
    [[ServerConnectionManager sharedInstance] startup];
}

#pragma mark - Properties

- (NSStatusItem *)appIcon {
    if (!_appIcon) {
        _appIcon = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        NSImage *image = [NSImage imageNamed:@"StatusBarIcon"];
        [_appIcon.button setImage:image];
    }
    return _appIcon;
}

#pragma mark - Actions

- (IBAction)exit:(id)sender {
    [NSApp terminate:self];
}

#pragma mark - Notifications

- (void)connectionStatusDidChange:(id<ServerProtocol>)server {
    self.stateMenuItem.title = [server description];
}

@end
