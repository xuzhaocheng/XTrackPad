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

@interface TrackPadViewController ()

@property (nonatomic, strong) TrackPadActionConsumer *actionConsumer;
@end

@implementation TrackPadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    TrackPadView *view = [[TrackPadView alloc] initWithFrame:self.view.bounds];
    view.delegate = self.actionConsumer;
    [self.view addSubview:view];
    
    self.title = @"XTrackPad";
}

- (TrackPadActionConsumer *)actionConsumer {
    if (!_actionConsumer) {
        _actionConsumer = [[TrackPadActionConsumer alloc] init];
    }
    return _actionConsumer;
}

@end
