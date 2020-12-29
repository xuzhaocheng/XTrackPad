//
//  TrackPadViewController.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import "TrackPadViewController.h"
#import "TrackPadView.h"
#import "NSString+i18n.h"
#import "TrackPadActionConsumer.h"
#import "ConnectionManager.h"

@interface TrackPadViewController ()

@property (nonatomic, strong) TrackPadView *trackPadView;
@property (nonatomic, strong) TrackPadActionConsumer *actionConsumer;

@end

@implementation TrackPadViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.trackPadView];
    [self addNotificationObserver];
    [self updateConnectionState];
}

- (void)addNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionStateDidChange) name:XTPConnectionStatusDidChange object:nil];
}

- (void)updateConnectionState {
    ConnectionState state = [ConnectionManager connectionState];
    switch (state) {
        case ConnectionStateConnected:
            self.title = @"Connected";
            break;
        case ConnectionStateConnecting:
            self.title = @"Connecting";
            break;
        case ConnectionStateNotConnected:
            self.title = @"No Connection";
            break;
        default:
            self.title = @"Unkown";
            break;
    }
}

#pragma mark - Notification

- (void)connectionStateDidChange {
    [self updateConnectionState];
}

#pragma mark - Properties

- (TrackPadView *)trackPadView {
    if (!_trackPadView) {
        TrackPadView *view = [[TrackPadView alloc] initWithFrame:self.view.bounds];
        view.delegate = self.actionConsumer;
        _trackPadView = view;
    }
    return _trackPadView;
}

- (TrackPadActionConsumer *)actionConsumer {
    if (!_actionConsumer) {
        _actionConsumer = [[TrackPadActionConsumer alloc] init];
    }
    return _actionConsumer;
}

@end
