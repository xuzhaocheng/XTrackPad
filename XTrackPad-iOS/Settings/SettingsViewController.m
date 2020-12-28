//
//  SettingsViewController.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/27.
//

#import "SettingsViewController.h"
#import "Settings.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISlider *cursorSpeedSlider;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cursorSpeedSlider.minimumValue = [Settings minCursorSpeed];
    self.cursorSpeedSlider.maximumValue = [Settings maxCursorSpeed];
    self.cursorSpeedSlider.value = [[Settings sharedInstance] cursorSpeed];
}

- (IBAction)cursorSpeedChanged:(UISlider *)sender {
    [[Settings sharedInstance] setCursorSpeed:sender.value];
}

@end
